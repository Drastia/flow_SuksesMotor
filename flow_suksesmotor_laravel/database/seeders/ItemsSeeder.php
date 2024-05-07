<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Item;

class ItemsSeeder extends Seeder
{
    public function run()
    {
        Item::create([
            'custom_id' => 'TYT001',
            'name' => 'Roda Toyota Alvero',
            'brand' => 'Toyota',
        ]);

        Item::create([
            'custom_id' => 'TYT002',
            'name' => 'Roda Toyota Alvero ex2',
            'brand' => 'Toyota',
        ]);

        Item::create([
            'custom_id' => 'SZK001',
            'name' => 'Roda Suzuki Mentera',
            'brand' => 'Suzuki',
        ]);

        Item::create([
            'custom_id' => 'SZK002',
            'name' => 'Roda Suzuki Mentera ex2',
            'brand' => 'Suzuki',
        ]);

        // Add more sample items as needed
    }
}
