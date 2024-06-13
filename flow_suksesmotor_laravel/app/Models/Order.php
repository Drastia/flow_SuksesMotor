<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class Order extends Model
{
    use HasFactory, HasApiTokens;

    protected $table = 'orders';
    protected $primaryKey = 'ID_pemesanan';
    protected $fillable = ['Tanggal_pemesanan', 'Tanggal_sampai', 'Nama_Vendor', 'Nama_Pemesan', 'checked'];

    public function orderList()
    {
        return $this->hasMany(OrderList::class, 'ID_pemesanan', 'ID_pemesanan');
    }
}
