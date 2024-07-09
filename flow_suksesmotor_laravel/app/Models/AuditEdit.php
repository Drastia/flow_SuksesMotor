<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class AuditEdit extends Model
{
    use HasFactory;

    protected $table = 'audit_edit';

    protected $fillable = [
        'table_name',
        'field_name',
        'old_value',
        'new_value',
        'changed_by',
        'role',
    ];

    // Define any additional relationships, attributes, or methods here
}