<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;

Route::middleware(['every-request'])->group(function (){
    Route::get('/product', [ProductController::class, 'getAllProduct']);
    Route::post('/product', [PorductController::class, 'addProduct']);
});