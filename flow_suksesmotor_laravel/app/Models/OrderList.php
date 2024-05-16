<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class OrderList extends Model
{
    use HasFactory,HasApiTokens;

    protected $table = 'order_list';
    protected $primaryKey = 'id';
    protected $fillable = ['ID_pemesanan', 'custom_id', 'name', 'brand', 'Quantity_ordered','Incoming_Quantity'.'checker_barang'];

    public function order()
    {
        return $this->belongsTo(Order::class, 'ID_pemesanan', 'ID_pemesanan');
    }

}
