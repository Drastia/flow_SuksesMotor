<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Item;
use App\Models\AuditEdit;
class ItemController extends Controller
{
    public function index()
    {
        $items = Item::all();
        return response()->json($items);
    }

    public function store(Request $request)
    {
        $request->validate([
            'custom_id' => 'required|unique:items|min:6|regex:/^[a-zA-Z0-9-]+$/',
            'name' => 'required|unique:items|min:6|regex:/^[a-zA-Z0-9 ]+$/',
            'brand' => 'required|regex:/^[a-zA-Z0-9 ]+$/',
        ]);

        $item = Item::create($request->all());

        return response()->json($item, 201);
    }

    public function search($query)
    {
        $item = Item::where('name', 'like', "%$query%")
        ->orWhere('custom_id', 'like', "%$query%")
        ->orWhere('brand', 'like', "%$query%")
        ->get();

        if (!$item) {
            return response()->json(['message' => 'Item not found'], 404);
            }

        return response()->json($item);
    }


    public function update(Request $request, $id,$adminName)
    {
      
    $item = Item::find($id);

   
    $oldValues = [
        'custom_id' => $item->custom_id,
        'name' => $item->name,
        'brand' => $item->brand,
    ];


    $item->update($request->only(['custom_id', 'name', 'brand']));
    $item->touch();


    $item->refresh(); 
    $newValues = [
        'custom_id' => $item->custom_id,
        'name' => $item->name,
        'brand' => $item->brand,
    ];


    foreach ($oldValues as $field => $oldValue) {
        $newValue = $newValues[$field];


        if ($oldValue !== $newValue) {

            AuditEdit::create([
                'table_name' => 'items',
                'field_name' => $field,
                'old_value' => $oldValue,
                'new_value' => $newValue,
                'changed_by' => $adminName, 
                'role' => 'Admin', 
            ]);
        }
    }
    return response()->json($item, 200);
    }

    public function destroy($id)
{
    $item = Item::find($id);

    if (!$item) {
        return response()->json(['message' => 'Item not found.'], 404);
    }

    $item->delete();

    return response()->json(null, 204);
}
}
