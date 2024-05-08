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
            $table->id();
            $table->date('tanggal_pemesanan');
            $table->date('tanggal_sampai');
            $table->string('nama_vendor');
            $table->string('nama_pemesan');
            $table->timestamps();
        });

        Schema::create('order_list', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('ID_pemesanan');
            $table->foreign('ID_pemesanan')->references('id')->on('orders')->onDelete('cascade');
            $table->string('custom_id');
            $table->string('name');
            $table->string('brand');
            $table->integer('quantity');
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
