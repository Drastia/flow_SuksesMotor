<?php

namespace database\seeders;

// WorkersSeeder.php
use Illuminate\Database\Seeder;
use App\Models\Worker;

class WorkersSeeder extends Seeder
{
    public function run()
    {
        Worker::create([
            'worker_name' => 'Demo',
            'worker_username' => 'Demo123',
            'worker_password' => bcrypt('Demo123'),
        ]);
    }
}

