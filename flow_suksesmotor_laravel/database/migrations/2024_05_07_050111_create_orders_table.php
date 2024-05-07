<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id('ID_pemesanan');
            $table->date('Tanggal_pemesanan');
            $table->date('Tanggal_sampai');
            $table->string('Nama_Vendor');
            $table->string('Nama_Pemesan');
            $table->timestamps();
        });

        Schema::create('order_list', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('ID_pemesanan');
            $table->foreign('ID_pemesanan')->references('ID_pemesanan')->on('orders')->onDelete('cascade');
            $table->string('custom_id');
            $table->string('name');
            $table->string('brand');
            $table->integer('Quantity');
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
