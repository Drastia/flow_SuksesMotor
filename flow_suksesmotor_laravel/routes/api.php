<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;


Route::post('/registerworker', [AuthController::class, 'registerworker']);
Route::post('/registeradmin', [AuthController::class, 'registeradmin']);

Route::post('/loginworker', [AuthController::class, 'loginworker']);
Route::post('/loginadmin', [AuthController::class, 'loginadmin']);

Route::middleware('auth:sactum')->get('/user',function (Request $request){
    return $request->user();
})

?>