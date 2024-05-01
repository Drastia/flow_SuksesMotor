<?php

namespace App\Http\Controllers;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{

    //
    public function register(Request $req)
    {
        //validate
        $rules=[
            'name' =>'required|string',
            'username'=>'required|string|unique:users',
            'password'=>'required|string|min:6'
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            return response()->json($validator->errors(), 400);
        }
        //create new user in users table
        $user = User::create([
            'name'=>$req->name,
            'username'=>$req->username,
            'password'=>Hash::make($req->password)
        ]);
        $token = $user->createToken('Personal Access Token')->plainTextToken;
        $response = ['user'=>$user, 'token'=>$token];
        return response()->json($response, 200);
    }

    public function login(Request $req)
    {
        //validate results
        $rules = [
            'username' => 'required',
            'password' =>'required|string'
        ];
        $req->validate($rules);
        //find user email in users table
        $user = User::where('username', $req->username)->first();
        //if user email found and password is correct
        if($user && Hash::check($req->password, $user->password)){
            $token = $user->createToken('Personal Access Token')->plainTextToken;
            $response = ['user'=>$user, 'token'=>$token];
            return response()->json($response, 200);
        }
        $response = ['message' =>'Incorrect email or password'];
        return response()->json($response, 400);
    }
}
