<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Item;

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
            'custom_id' => 'required|unique:items|min:6|regex:/^[a-zA-Z0-9]+$/',
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

    public function edit($id){
        $item = Item::find($id);
        return response()->json($item);

    }
    public function update(Request $request, $id)
    {
        // Define validation rules
        $item = Item::find($id);
        $item->update($request->all());
        return response()->json($item, 200);

    // $rules = [
    //     'brand' => 'required',
    //     'custom_id' => 'sometimes|required|unique:items,custom_id,' . $item->id,
    //     'name' => 'sometimes|required|unique:items,name,' . $item->id,
    // ];

    // // Validate the request data
    // $request->validate($rules);

    // // Update only the fields present in the request
    // $item->update($request->only(['custom_id', 'name', 'brand']));

    // return response()->json($item, 200);
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
