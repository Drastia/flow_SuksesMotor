<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Order;
use App\Models\OrderList;
use App\Models\AuditEdit;
use App\Models\Item;
use App\Models\Worker;
use App\Models\Admin;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;

class ReportController extends Controller

{
    
    public function getReportData($datefrom, $dateto)
    {
        $adminData = [];
        $adminDataEdit = [];
        $workerData = [];
        $workerDataEdit = [];
        $itemsData = [];
        $itemsDataEdit = [];
        $ordersData = [];
        $ordersDataEdit = [];
        $orderListData = [];
        $orderListDataEdit = [];
        $auditEdit = [];
        //$today = Carbon::today()->toDateString();
        if ($datefrom == $dateto) {
            $adminData = DB::table('admin_table')
                ->whereDate('created_at', $datefrom)
                ->get();
            $adminDataEdit = DB::table('admin_table')
            ->whereDate('updated_at',$datefrom)
                ->whereColumn('updated_at', '!=', 'created_at')
                ->get();
            $workerData = DB::table('workers')
                ->whereDate('created_at', $datefrom)
                ->get();
    
            $workerDataEdit = DB::table('workers')
                ->whereDate('updated_at',$datefrom)
                ->whereColumn('updated_at', '!=', 'created_at')
                ->get();
    
            $itemsData = DB::table('items')
                ->whereDate('created_at', $datefrom)
                ->get();
    
            $itemsDataEdit = DB::table('items')
                ->whereDate('updated_at',$datefrom)
                ->whereColumn('updated_at', '!=', 'created_at')
                ->get();
    
            $ordersData = DB::table('orders')
                ->whereDate('created_at',$datefrom)
                ->get();
            
            $ordersDataEdit = DB::table('orders')
                ->whereDate('updated_at',$datefrom)
                ->whereColumn('updated_at', '!=', 'created_at')
                ->get();
    
            $orderListData = DB::table('order_list')
                ->whereDate('created_at',$datefrom)
                ->get();
            
            $orderListDataEdit = DB::table('order_list')
                ->whereDate('updated_at', $datefrom)
                ->whereColumn('updated_at', '!=', 'created_at')
                ->get();
    
            $auditEdit = DB::table('audit_edit')
                ->whereDate('created_at', $datefrom)
                ->get();
        } else {
            $adminData = DB::table('admin_table')
            ->whereBetween('created_at', [$datefrom, $dateto])
            ->get();

            $adminDataEdit = DB::table('admin_table')
            ->whereBetween('updated_at', [$datefrom, $dateto])
            ->whereColumn('updated_at', '!=', 'created_at')
            ->get();

            $workerData = DB::table('workers')
            ->whereBetween('created_at', [$datefrom, $dateto])
            ->get();

        $workerDataEdit = DB::table('workers')
            ->whereBetween('updated_at', [$datefrom, $dateto])
            ->whereColumn('updated_at', '!=', 'created_at')
            ->get();

        $itemsData = DB::table('items')
            ->whereBetween('created_at', [$datefrom, $dateto])
            ->get();

        $itemsDataEdit = DB::table('items')
            ->whereBetween('updated_at',[$datefrom, $dateto])
            ->whereColumn('updated_at', '!=', 'created_at')
            ->get();

        $ordersData = DB::table('orders')
            ->whereBetween('created_at',[$datefrom, $dateto])
            ->get();
        
        $ordersDataEdit = DB::table('orders')
            ->whereBetween('updated_at', [$datefrom, $dateto])
            ->whereColumn('updated_at', '!=', 'created_at')
            ->get();

        $orderListData = DB::table('order_list')
            ->whereBetween('created_at', [$datefrom, $dateto])
            ->get();
        
        $orderListDataEdit = DB::table('order_list')
            ->whereBetween('updated_at', [$datefrom, $dateto])
            ->whereColumn('updated_at', '!=', 'created_at')
            ->get();

        $auditEdit = DB::table('audit_edit')
            ->whereBetween('created_at', [$datefrom, $dateto])
            ->get();
        }
        

       

       


        

            $data = [
                'admin_table' => $adminData,
                'admin_table_edit' => $adminDataEdit,
                'workers' => $workerData,
                'workers_edit' => $workerDataEdit,
                'items' => $itemsData,
                'items_edit' => $itemsDataEdit,
                'orders' => $ordersData,
                'orders_edit' => $ordersDataEdit,
                'order_list' => $orderListData ,
                'order_list_edit' => $orderListDataEdit,
                'audit_edit'=>  $auditEdit
            ];
    
            return response()->json($data);
    }
}