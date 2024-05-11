<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Order;
use App\Models\OrderList;
use App\Models\Item;
use Illuminate\Http\JsonResponse;

class OrderController extends Controller
{

    public function index(): JsonResponse
    {
        $orders = Order::all();
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
    // Method to store a newly created order and its order list items
    public function store(Request $request): JsonResponse
    {
        // Validate the incoming request data
        $request->validate([
            'Tanggal_pemesanan' => 'required',
            'Tanggal_sampai' => 'required',
            'Nama_Vendor' => 'required',
            'Nama_Pemesan' => 'required',
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
        'items.*.Quantity' => 'required|numeric|min:1',
    ]);

    /// Find the order
    $order = Order::findOrFail($id);

    // Update order list items
    foreach ($request->items as $item) {
        // Find the specific order list item to update
        $orderListItem = OrderList::where([
            'ID_pemesanan' => $order->ID_pemesanan,
            'custom_id' => $item['custom_id'],
        ])->first();

        // Update the order list item if found
        if ($orderListItem) {
            $orderListItem->update([
                'name' => $item['name'],
                'brand' => $item['brand'],
                'Quantity' => $item['Quantity']
            ]);
        }
    }

    // Return a JSON response
    return response()->json(['message' => 'Order list items updated successfully.'], 200);
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
}




