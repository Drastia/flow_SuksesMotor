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
        Schema::create('audit_edit', function (Blueprint $table) {
            $table->id();
            $table->string('table_name');
            $table->string('field_name');
            $table->text('old_value'); 
            $table->text('new_value'); 
            $table->string('changed_by');
            $table->string('role');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('audit_edit');
    }
};
