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
    public function getReportData()
    {
        $today = Carbon::today()->toDateString();

        $adminData = DB::table('admin_table')
            ->whereDate('created_at', $today)
            ->get();

        $adminDataEdit = DB::table('admin_table')
            ->whereDate('updated_at', $today)
            ->whereColumn('updated_at', '!=', 'created_at')
            ->get();

        $workerData = DB::table('workers')
            ->whereDate('created_at', $today)
            ->get();

        $workerDataEdit = DB::table('workers')
            ->whereDate('updated_at', $today)
            ->whereColumn('updated_at', '!=', 'created_at')
            ->get();

        $itemsData = DB::table('items')
            ->whereDate('created_at', $today)
            ->get();

        $itemsDataEdit = DB::table('items')
            ->whereDate('updated_at', $today)
            ->whereColumn('updated_at', '!=', 'created_at')
            ->get();

        $ordersData = DB::table('orders')
            ->whereDate('created_at', $today)
            ->get();
        
        $ordersDataEdit = DB::table('orders')
            ->whereDate('updated_at', $today)
            ->whereColumn('updated_at', '!=', 'created_at')
            ->get();

        $orderListData = DB::table('order_list')
            ->whereDate('created_at', $today)
            ->get();
        
        $orderListDataEdit = DB::table('order_list')
            ->whereDate('updated_at', $today)
            ->whereColumn('updated_at', '!=', 'created_at')
            ->get();

        $auditEdit = DB::table('audit_edit')
            ->whereDate('created_at', $today)
            ->get();


        

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