<?php

namespace App\Http\Controllers;
use App\Models\Worker;
use App\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{

    //
    public function registeradmin(Request $req)
    {
        //validate
        $rules=[
            'admin_name' =>'required|string',
            'admin_username'=>'required|string|unique:admin_table',
            'admin_password'=>'required|string|min:6'
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            return response()->json($validator->errors(), 400);
        }
        //create new user in users table
        $admin = Admin::create([
            'admin_name'=>$req->admin_name,
            'admin_username'=>$req->admin_username,
            'admin_password'=>Hash::make($req->admin_password)
        ]);
        $token = $admin->createToken('Personal Access Token')->plainTextToken;
        $response = ['admin'=>$admin, 'token'=>$token];
        return response()->json($response, 200);
    }

    public function registerworker(Request $req)
    {
        //validate
        $rules=[
            'worker_name' =>'required|string',
            'worker_username'=>'required|string|unique:worker_table',
            'worker_password'=>'required|string|min:6'
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            return response()->json($validator->errors(), 400);
        }
        //create new user in users table
        $worker = Worker::create([
            'worker_name'=>$req->worker_name,
            'worker_username'=>$req->worker_username,
            'worker_password'=>Hash::make($req->worker_password)
        ]);
        $token = $worker->createToken('Personal Access Token')->plainTextToken;
        $response = ['worker'=>$worker, 'token'=>$token];
        return response()->json($response, 200);
    }

    public function loginadmin(Request $req)
    {
        //validate results
        $rules = [
            'admin_username' => 'required',
            'admin_password' =>'required|string'
        ];
        $req->validate($rules);
        //find user email in users table
        $admin = Admin::where('admin_username', $req->admin_username)->first();
        //if user email found and password is correct
        if($admin && Hash::check($req->admin_password, $admin->admin_password)){
            $token = $admin->createToken('Personal Access Token')->plainTextToken;
            $response = ['admin'=>$admin, 'token'=>$token];
            return response()->json($response, 200);
        }
        $response = ['message' =>'Incorrect email or password'];
        return response()->json($response, 400);
    }

    public function loginworker(Request $req)
    {
        //validate results
        $rules = [
            'worker_username' => 'required',
            'worker_password' =>'required|string'
        ];
        $req->validate($rules);
        //find user email in users table
        $worker = Worker::where('worker_username', $req->worker_username)->first();
        //if user email found and password is correct
        if($worker && Hash::check($req->worker_password, $worker->worker_password)){
            $token = $worker->createToken('Personal Access Token')->plainTextToken;
            $response = ['worker'=>$worker, 'token'=>$token];
            return response()->json($response, 200);
        }
        $response = ['message' =>'Incorrect email or password'];
        return response()->json($response, 400);
    }
}
