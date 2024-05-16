<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ItemController;
use App\Http\Controllers\OrderController;



Route::post('/registeradmin', [AuthController::class, 'registeradmin']);
Route::post('/loginadmin', [AuthController::class, 'loginadmin']);
Route::get('/admin', [AuthController::class, 'indexAdmin']);
Route::put('/updateadmin/{id}', [AuthController::class, 'updateAdmin']);
Route::delete('/deleteadmin/{id}', [AuthController::class, 'destroyAdmin']);

Route::post('/registerworker', [AuthController::class, 'registerworker']);
Route::post('/loginworker', [AuthController::class, 'loginworker']);
Route::get('/worker', [AuthController::class, 'indexWorker']);
Route::put('/updateworker/{id}', [AuthController::class, 'updateWorker']);
Route::delete('/deleteworker/{id}', [AuthController::class, 'destroyWorker']);

Route::get('/getitems', [ItemController::class, 'index']); // GET /items
Route::post('/storeitems', [ItemController::class, 'store']); // POST /items
Route::get('/searchitem/{item}', [ItemController::class, 'search']); // GET /items/{keywords}
Route::get('/updateitems/{id}/edit', [ItemController::class, 'edit']);
Route::put('/updateitems/{id}', [ItemController::class, 'update']); // PUT /items/{id}
Route::delete('/deleteitems/{id}', [ItemController::class, 'destroy']); // DELETE /items/{id}

Route::prefix('orders')->group(function () {
    Route::get('/', [OrderController::class, 'index']);
    Route::post('/', [OrderController::class, 'store']);
    Route::get('/list/{id}', [OrderController::class, 'indexOrderList']);
    Route::get('/{id}', [OrderController::class, 'show']);
    Route::put('/{id}', [OrderController::class, 'updateOrder']);
    //Route::put('/{id}/items', [OrderController::class, 'updateOrderListItems']);
    Route::delete('/{id}', [OrderController::class, 'destroy']);
    Route::delete('/{id}/items', [OrderController::class, 'destroyItem']);
    
});


Route::middleware('auth:sactum')->get('/user',function (Request $request){
    return $request->user();
})

?>