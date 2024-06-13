<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Carbon\Carbon;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->bigIncrements('ID_pemesanan');
            $table->date('tanggal_pemesanan');
            $table->date('tanggal_sampai');
            $table->string('nama_vendor');
            $table->string('nama_pemesan');
            $table->string('checked')->default('');
            $table->timestamps();
        });

        Schema::create('order_list', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('ID_pemesanan');
            $table->foreign('ID_pemesanan')->references('ID_pemesanan')->on('orders')->onDelete('cascade');
            $table->string('custom_id');
            $table->string('name');
            $table->string('brand');

            $table->integer('Quantity_ordered');
            $table->integer('Incoming_Quantity')->default(0);
            $table->string('checker_barang')->default('');
            $table->string('ismatch')->default('');

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
        Schema::dropIfExists('order_list');
    }
};
