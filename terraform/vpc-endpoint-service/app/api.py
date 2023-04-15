#!/usr/bin/env python
# vim: set syntax=python:

from flask import Flask, request, jsonify

app = Flask(__name__)

# Sample inventory data
inventory = [
    {
        "id": 1,
        "name": "Product 1",
        "description": "Description for product 1",
        "price": 9.99,
        "quantity": 10
    },
    {
        "id": 2,
        "name": "Product 2",
        "description": "Description for product 2",
        "price": 19.99,
        "quantity": 5
    },
    {
        "id": 3,
        "name": "Product 3",
        "description": "Description for product 3",
        "price": 29.99,
        "quantity": 2
    }
]

# Sample user data
users = [
    {
        "id": 1,
        "name": "User 1",
        "email": "user1@example.com",
        "password": "password1"
    },
    {
        "id": 2,
        "name": "User 2",
        "email": "user2@example.com",
        "password": "password2"
    }
]

# Endpoint to get all products
@app.route("/products", methods=["GET"])
def get_products():
    return jsonify(inventory)

# Endpoint to get a specific product by id
@app.route("/products/<int:product_id>", methods=["GET"])
def get_product(product_id):
    product = next((p for p in inventory if p["id"] == product_id), None)
    if product:
        return jsonify(product)
    else:
        return jsonify({"message": "Product not found"}), 404

# Endpoint to create a new order
@app.route("/orders", methods=["POST"])
def create_order():
    data = request.json
    user = next((u for u in users if u["email"] == data["email"] and u["password"] == data["password"]), None)
    if not user:
        return jsonify({"message": "Invalid email or password"}), 401
    order_total = 0
    for item in data["items"]:
        product = next((p for p in inventory if p["id"] == item["product_id"]), None)
        if not product:
            return jsonify({"message": f"Product with id {item['product_id']} not found"}), 400
        if item["quantity"] > product["quantity"]:
            return jsonify({"message": f"Not enough quantity for product with id {item['product_id']}"}), 400
        order_total += product["price"] * item["quantity"]
        product["quantity"] -= item["quantity"]
    return jsonify({"message": "Order created", "total": order_total})

if __name__ == "__main__":
    app.run(host="0.0.0.0")
