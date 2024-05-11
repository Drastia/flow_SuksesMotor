<?php

namespace database\seeders;

// AdminSeeder.php
use Illuminate\Database\Seeder;
use App\Models\Admin;

class AdminSeeder extends Seeder
{
    public function run()
    {
        Admin::create([
            'admin_name' => 'Orlando',
            'admin_username' => 'Orlando123',
            'admin_password' => bcrypt('Orlando123'),
        ]);
    }
}

