<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;
use Validator;

class ProductController extends Controller
{
    public function getAllProduct()
    {
        $product = Product::all();
        return response()->json($product);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'price' => 'required|numeric',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $product = new Product();
        $product->name = $request->input('name');
        $product->price = $request->input('price');
        $product->description = $request->input('description', '');

        if ($product->save()) {
            return response()->json(['message' => 'Product created successfully', 'product' => $product], 201);
        } else {
            return response()->json(['message' => 'Product creation failed'], 500);
        }
    }

    public function addProduct(Request $request)
    {
        $product = new Product();
        $product->nama = $request->nama;
        $product->jumlah = $request->jumlah;
        $product->harga = $request->harga;
        $product->image = $request->image;
        $product->save();
        return response()->json($product);
    }
}