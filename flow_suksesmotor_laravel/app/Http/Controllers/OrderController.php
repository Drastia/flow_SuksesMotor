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
    $today = Carbon::today(); 
    $orders = Order::where('tanggal_sampai', '>=', $today)->get();
    return response()->json($orders);
}
    public function IndexBeforetoday(){
        $today = Carbon::today(); 
    $orders = Order::where('tanggal_sampai', '<' ,$today)->get();
    return response()->json($orders);
    }

    public function indexOrderList($id): JsonResponse
{
    
    $orderlist = OrderList::where('ID_pemesanan', $id)->get();
    
    
    if($orderlist->isEmpty()) {
        return response()->json(['message' => 'No order list found for the provided order ID.'], 404);
    }

    
    return response()->json($orderlist);
}

public function searchOrder($query)
{
    $today = Carbon::today();

    
    $order = Order::where('tanggal_sampai', '>=', $today)
        ->where(function($queryBuilder) use ($query) {
            $queryBuilder->where('ID_pemesanan', 'like', "%$query%")
                ->orWhere('Tanggal_pemesanan', 'like', "%$query%")
                ->orWhere('Tanggal_sampai', 'like', "%$query%")
                ->orWhere('Nama_Vendor', 'like', "%$query%")
                ->orWhere('Nama_Pemesan', 'like', "%$query%");
        })
        ->get();

    
    if ($order->isEmpty()) {
        return response()->json(['message' => 'Order not found'], 404);
    }

    return response()->json($order);
}

public function searchOrderHistory($query)
{
    $today = Carbon::today();

    
  
        $order = Order::where('tanggal_sampai', '<', $today)
            ->where(function($queryBuilder) use ($query) {
                $queryBuilder->where('ID_pemesanan', 'like', "%$query%")
                    ->orWhere('Tanggal_pemesanan', 'like', "%$query%")
                    ->orWhere('Tanggal_sampai', 'like', "%$query%")
                    ->orWhere('Nama_Vendor', 'like', "%$query%")
                    ->orWhere('Nama_Pemesan', 'like', "%$query%");
            })
            ->get();
    

    
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
        
        $request->validate([
            'Tanggal_pemesanan' => 'required|regex:/^[a-zA-Z0-9-]+$/',
            'Tanggal_sampai' => 'required|regex:/^[a-zA-Z0-9-]+$/',
            'Nama_Vendor' => 'required|regex:/^[a-zA-Z0-9 ]+$/',
            'Nama_Pemesan' => 'required|regex:/^[a-zA-Z0-9 ]+$/',
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
            
        ]);

        
        $order = Order::create($request->only(['Tanggal_pemesanan', 'Tanggal_sampai', 'Nama_Vendor', 'Nama_Pemesan']));

        
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

        
        return response()->json(['message' => 'Order created successfully.'], 201);
    }



    public function updateOrder(Request $request, $id): JsonResponse
{
    
    $request->validate([
        'Tanggal_pemesanan' => 'required',
        'Tanggal_sampai' => 'required',
        'Nama_Vendor' => 'required',
        'Nama_Pemesan' => 'required',
    ]);

    
    $order = Order::findOrFail($id);

    
    $order->update($request->only(['Tanggal_pemesanan', 'Tanggal_sampai', 'Nama_Vendor', 'Nama_Pemesan']));

    
    return response()->json(['message' => 'Order updated successfully.'], 200);
}
    
   


    
    
    public function updateOrderListItems(Request $request, $id): JsonResponse
    {
        
        $request->validate([
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
        ]);
    
        
        $order = Order::findOrFail($id);
    
        
        foreach ($request->items as $item) {
            
            $orderListItem = OrderList::where([
                'ID_pemesanan' => $order->ID_pemesanan,
                'custom_id' => $item['custom_id'],
            ])->first();
    
            
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

    
    $item = $request->items[0];

    
    \Log::info('Incoming Request Data:', [$item]);

    
    $orderListItem = OrderList::where([
        'ID_pemesanan' => $id,
        'custom_id' => $item['custom_id'],
        'name'=> $item['name'],
    ])->first();

    
    if ($orderListItem) {
        $orderListItem->update([
            'Incoming_Quantity' => $item['Incoming_Quantity'],
            'ismatch' => $item['Incoming_Quantity'] == $item['Quantity_ordered'] ? 'true' : 'false',
            'checker_barang' => $item['checker_barang']
        ]);

        
        $orderItems = OrderList::where('ID_pemesanan', $id)->get();

        
        $allItemsMatch = $orderItems->every(function ($orderItem) {
            return $orderItem->Incoming_Quantity == $orderItem->Quantity_ordered;
        });

        
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



    
    
    public function destroy($id): JsonResponse
    {
        
        $order = Order::findOrFail($id);
        $order->delete();

        
        return response()->json(['message' => 'Order list deleted successfully.'], 204);
    }

    public function destroyItem($id): JsonResponse
{
    
    $orderListItem = OrderList::findOrFail($id);
    $orderListItem->delete();

    
    return response()->json(['message' => 'Order list item deleted successfully.'], 204);
}

}




