<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Order;
use App\Models\OrderList;
use App\Models\Item;
use App\Models\Worker;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;

use Illuminate\Http\JsonResponse;

class OrderController extends Controller
{

    public function IndexAftertoday(): JsonResponse
{
    $today = Carbon::today(); // Get today's date
    $orders = Order::where('tanggal_sampai', '>=', $today)->get();
    return response()->json($orders);
}
    public function IndexBeforetoday(){
        $today = Carbon::today(); // Get today's date
    $orders = Order::where('tanggal_sampai', '<' ,$today)->get();
    return response()->json($orders);
    }

    public function indexOrderList($id): JsonResponse
{
    // Retrieve order list data based on the provided order ID
    $orderlist = OrderList::where('ID_pemesanan', $id)->get();
    
    // Check if any order list data is found
    if($orderlist->isEmpty()) {
        return response()->json(['message' => 'No order list found for the provided order ID.'], 404);
    }

    // Return the order list data as JSON response
    return response()->json($orderlist);
}

public function searchOrder($query)
{
    $today = Carbon::today();

    // Default behavior to filter orders with `tanggal_sampai` after today
    $order = Order::where('tanggal_sampai', '>=', $today)
        ->where(function($queryBuilder) use ($query) {
            $queryBuilder->where('ID_pemesanan', 'like', "%$query%")
                ->orWhere('Tanggal_pemesanan', 'like', "%$query%")
                ->orWhere('Tanggal_sampai', 'like', "%$query%")
                ->orWhere('Nama_Vendor', 'like', "%$query%")
                ->orWhere('Nama_Pemesan', 'like', "%$query%");
        })
        ->get();

    // Return 404 if no items are found
    if ($order->isEmpty()) {
        return response()->json(['message' => 'Order not found'], 404);
    }

    return response()->json($order);
}

public function searchOrderHistory($query)
{
    $today = Carbon::today();

    // Default behavior to filter orders with `tanggal_sampai` after today
  
        $order = Order::where('tanggal_sampai', '<', $today)
            ->where(function($queryBuilder) use ($query) {
                $queryBuilder->where('ID_pemesanan', 'like', "%$query%")
                    ->orWhere('Tanggal_pemesanan', 'like', "%$query%")
                    ->orWhere('Tanggal_sampai', 'like', "%$query%")
                    ->orWhere('Nama_Vendor', 'like', "%$query%")
                    ->orWhere('Nama_Pemesan', 'like', "%$query%");
            })
            ->get();
    

    // Return 404 if no items are found
    if ($order->isEmpty()) {
        return response()->json(['message' => 'Order not found'], 404);
    }

    return response()->json($order);
}


public function searchOrderItem($id,$query){
    $orderitem = OrderList::where('ID_pemesanan', $id)
    ->where (function($queryBuilder) use ($query) {
        $queryBuilder->where('name', 'like', "%$query%")
        ->orWhere('custom_id', 'like', "%$query%")
        ->orWhere('brand', 'like', "%$query%");
    })
    ->get();

    if (!$orderitem) {
        return response()->json(['message' => 'Oreer item not found'], 404);
        }

     return response()->json($orderitem);
}
  

    public function store(Request $request): JsonResponse
    {
        // Validate the incoming request data
        $request->validate([
            'Tanggal_pemesanan' => 'required|regex:/^[a-zA-Z0-9]+$/',
            'Tanggal_sampai' => 'required|regex:/^[a-zA-Z0-9]+$/',
            'Nama_Vendor' => 'required|regex:/^[a-zA-Z0-9]+$/',
            'Nama_Pemesan' => 'required|regex:/^[a-zA-Z0-9]+$/',
            'items.*.custom_id' => [
                'required',
                function ($attribute, $value, $fail) {
                    // Check if the item with the specified ID exists in the items table
                    $itemExists = Item::where('custom_id', $value)->exists();
                    if (!$itemExists) {
                        $fail("The $attribute does not exist in the items table.");
                    }
                },
            ],
            'items.*.name' => 'required',
            'items.*.brand' => 'required',
            
        ]);

        // Create the order
        $order = Order::create($request->only(['Tanggal_pemesanan', 'Tanggal_sampai', 'Nama_Vendor', 'Nama_Pemesan']));

        // Create order list items
        foreach ($request->items as $item) {
            OrderList::create([
                'ID_pemesanan' => $order->ID_pemesanan,
                'custom_id' => $item['custom_id'],
                'name' => $item['name'],
                'brand' => $item['brand'],
                'Quantity_ordered' => $item['Quantity_ordered'],
                'Incoming_Quantity' => 0,
                'checker_barang' => '',
                'ismatch' => '',

            ]);
        }

        // Return a JSON response
        return response()->json(['message' => 'Order created successfully.'], 201);
    }



    public function updateOrder(Request $request, $id): JsonResponse
{
    // Validate the incoming request data for order details
    $request->validate([
        'Tanggal_pemesanan' => 'required',
        'Tanggal_sampai' => 'required',
        'Nama_Vendor' => 'required',
        'Nama_Pemesan' => 'required',
    ]);

    // Find the order
    $order = Order::findOrFail($id);

    // Update order details
    $order->update($request->only(['Tanggal_pemesanan', 'Tanggal_sampai', 'Nama_Vendor', 'Nama_Pemesan']));

    // Return a JSON response
    return response()->json(['message' => 'Order updated successfully.'], 200);
}
    
   


    // Method to update a specific order
    // Method to update all order list items for a specific order
    public function updateOrderListItems(Request $request, $id): JsonResponse
    {
        // Validate the incoming request data for order list items
        $request->validate([
            'items.*.custom_id' => [
                'required',
                function ($attribute, $value, $fail) {
                    // Check if the item with the specified ID exists in the items table
                    $itemExists = Item::where('custom_id', $value)->exists();
                    if (!$itemExists) {
                        $fail("The $attribute does not exist in the items table.");
                    }
                },
            ],
            'items.*.name' => 'required',
            'items.*.brand' => 'required',
            'items.*.Quantity_ordered' => 'required|numeric|min:1',
        ]);
    
        // Find the order
        $order = Order::findOrFail($id);
    
        // Update or add order list items
        foreach ($request->items as $item) {
            // Find the specific order list item to update
            $orderListItem = OrderList::where([
                'ID_pemesanan' => $order->ID_pemesanan,
                'custom_id' => $item['custom_id'],
            ])->first();
    
            // Update the order list item if found, otherwise create a new one
            if ($orderListItem) {
                $orderListItem->update([
                    'name' => $item['name'],
                    'brand' => $item['brand'],
                    'Quantity_ordered' => $item['Quantity_ordered']
                ]);
            } else {
                OrderList::create([
                    'ID_pemesanan' => $order->ID_pemesanan,
                    'custom_id' => $item['custom_id'],
                    'name' => $item['name'],
                    'brand' => $item['brand'],
                    'Quantity_ordered' => $item['Quantity_ordered']
                ]);
            }
        }
    
        // Return a JSON response
        return response()->json(['message' => 'Order list items updated successfully.'], 200);
    }
    
    public function updateQuantityArrived(Request $request, $id): JsonResponse
{
    $request->validate([
        'items' => 'required|array|size:1',
        'items.*.custom_id' => [
            'required',
            function ($attribute, $value, $fail) {
                $itemExists = Item::where('custom_id', $value)->exists();
                if (!$itemExists) {
                    $fail("The $attribute does not exist in the items table.");
                }
            },
        ],
        'items.*.name' => 'required',
        'items.*.brand' => 'required',
        'items.*.Quantity_ordered' => 'required|numeric|min:1',
        'items.*.Incoming_Quantity' => 'required|numeric|min:0',
    ]);

    // Get the single item from the request
    $item = $request->items[0];

    // Log the incoming data for debugging
    \Log::info('Incoming Request Data:', [$item]);

    // Find the specific order list item to update
    $orderListItem = OrderList::where([
        'ID_pemesanan' => $id,
        'custom_id' => $item['custom_id'],
        'name'=> $item['name'],
    ])->first();

    // Update the order list item if found, otherwise return a not found response
    if ($orderListItem) {
        $orderListItem->update([
            'Incoming_Quantity' => $item['Incoming_Quantity'],
            'ismatch' => $item['Incoming_Quantity'] == $item['Quantity_ordered'] ? 'true' : 'false',
            'checker_barang' => $item['checker_barang']
        ]);

        // Retrieve all items associated with the specific ID_pemesanan
        $orderItems = OrderList::where('ID_pemesanan', $id)->get();

        // Check if all items have Incoming_Quantity equal to Quantity_ordered
        $allItemsMatch = $orderItems->every(function ($orderItem) {
            return $orderItem->Incoming_Quantity == $orderItem->Quantity_ordered;
        });

        // Update the checked column in the Order table if all items match
        if ($allItemsMatch) {
            Order::where('ID_pemesanan', $id)->update(['checked' => 'true']);
        }
        else{
            Order::where('ID_pemesanan', $id)->update(['checked' => 'false']);
        }

        return response()->json(['message' => 'Order item updated successfully!']);
    } else {
        return response()->json(['message' => 'Order list item not found.'], 404);
    }
}



    
    // Method to delete a specific order
    public function destroy($id): JsonResponse
    {
        // Find the order and delete it
        $order = Order::findOrFail($id);
        $order->delete();

        // Return a JSON response
        return response()->json(['message' => 'Order list deleted successfully.'], 204);
    }

    public function destroyItem($id): JsonResponse
{
    // Find the order list item and delete it
    $orderListItem = OrderList::findOrFail($id);
    $orderListItem->delete();

    // Return a JSON response
    return response()->json(['message' => 'Order list item deleted successfully.'], 204);
}

}




