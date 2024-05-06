<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ItemController;


Route::post('/registerworker', [AuthController::class, 'registerworker']);
Route::post('/registeradmin', [AuthController::class, 'registeradmin']);

Route::post('/loginworker', [AuthController::class, 'loginworker']);
Route::post('/loginadmin', [AuthController::class, 'loginadmin']);

Route::get('/getitems', [ItemController::class, 'index']); // GET /items
Route::post('/storeitems', [ItemController::class, 'store']); // POST /items
Route::get('/searchitem/{item}', [ItemController::class, 'search']); // GET /items/{keywords}
Route::get('/updateitems/{id}/edit', [ItemController::class, 'edit']);
Route::put('/updateitems/{id}', [ItemController::class, 'update']); // PUT /items/{id}
Route::delete('/deleteitems/{id}', [ItemController::class, 'destroy']); // DELETE /items/{id}

Route::middleware('auth:sactum')->get('/user',function (Request $request){
    return $request->user();
})

?>