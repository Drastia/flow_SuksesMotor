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
        //from users 
        Schema::create('admin_table', function (Blueprint $table) {
            $table->id();
            $table->string('admin_name');
            $table->string('admin_username')->unique();
            $table->timestamp('username_verified_at')->nullable();
            $table->string('admin_password');
            $table->rememberToken();
            $table->timestamps();
        });

        Schema::create('workers', function (Blueprint $table) {
            $table->id();
            $table->string('worker_name');
            $table->string('worker_username')->unique();
            $table->timestamp('username_verified_at')->nullable();
            $table->string('worker_password');
            $table->rememberToken();
            $table->timestamps();
        });

        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('username')->primary();
            $table->string('token');
            $table->timestamp('created_at')->nullable();
        });

        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->foreignId('user_id')->nullable()->index();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->longText('payload');
            $table->integer('last_activity')->index();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('admin_table');
        Schema::dropIfExists('worker_table');
        
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('sessions');
    }
};
