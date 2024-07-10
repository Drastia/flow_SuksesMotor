<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ItemController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\ReportController;






Route::post('/registeradmin', [AuthController::class, 'registeradmin']);
Route::post('/loginadmin', [AuthController::class, 'loginadmin']);
Route::get('/admin', [AuthController::class, 'indexAdmin']);
Route::put('/updateadmin/{id}/{adminName}', [AuthController::class, 'updateAdmin']);
Route::delete('/deleteadmin/{id}', [AuthController::class, 'destroyAdmin']);

Route::post('/registerworker', [AuthController::class, 'registerworker']);
Route::post('/loginworker', [AuthController::class, 'loginworker']);
Route::get('/worker', [AuthController::class, 'indexWorker']);
Route::put('/updateworker/{id}/{adminName}', [AuthController::class, 'updateWorker']);
Route::delete('/deleteworker/{id}', [AuthController::class, 'destroyWorker']);

Route::get('/getitems', [ItemController::class, 'index']); 
Route::post('/storeitems', [ItemController::class, 'store']); 
Route::get('/searchitem/{item}', [ItemController::class, 'search']); 
Route::put('/updateitems/{id}/{adminName}', [ItemController::class, 'update']); 
Route::delete('/deleteitems/{id}', [ItemController::class, 'destroy']); 

Route::prefix('orders')->group(function () {
    Route::get('/IndexAftertoday', [OrderController::class, 'IndexAftertoday']);
    Route::get('/IndexBeforetoday', [OrderController::class, 'IndexBeforetoday']);
    Route::get('/countOrdersByDate', [OrderController::class, 'countOrdersByDate']);
    Route::get('/getOrdersByDate/{date}', [OrderController::class, 'getOrdersByDate']);
    Route::post('/', [OrderController::class, 'store']);
    Route::get('/list/{id}', [OrderController::class, 'indexOrderList']);
    Route::get('/searchOrder/{order}', [OrderController::class, 'searchOrder']);
    Route::get('/searchOrderHistory/{order}', [OrderController::class, 'searchOrderHistory']);
    Route::get('/searchOrderItem/{id}/{orderitem}', [OrderController::class, 'searchOrderItem']);
    Route::put('/{id}/{adminName}', [OrderController::class, 'updateOrder']);
    Route::put('/{id}/{adminName}/items', [OrderController::class, 'updateOrderListItems']);
    Route::put('/{id}/{workerName}/quantity-item', [OrderController::class, 'updateQuantityArrived']);
    
    Route::delete('/{id}', [OrderController::class, 'destroy']);
    Route::delete('/{id}/items', [OrderController::class, 'destroyItem']);

});

Route::get('/report-data', [ReportController::class, 'getReportData']);

Route::middleware('auth:sactum')->get('/user',function (Request $request){
    return $request->user();
})

?>