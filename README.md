# ETB
<div style="text-align: center;"> <h3></h3> <p><strong>Database Management Project</strong></p>
<p><strong>Group: 09</strong></p>


<p text-align: center><strong>Submitted to: Prof. Ashok Harnal</strong></p>


<p text-align: center><strong>Submitted By:</strong></p>

<ul>
    <li>Disha Hirwani - 341127</li>
    <li>Dilip Baduwal - 341135</li>
    <li>Janvi joshi - 341159</li>
</ul>
</div>

# End‑to‑End B2B E‑Commerce Supply Chain Management for Udaan‑Style Marketplace

This project designs a relational database for a Udaan‑style B2B e‑commerce supply chain that connects Customers (retailers) with Suppliers (brands and distributors) through a network of Warehouses, Drivers, Products, and SKUs, while capturing Orders and Logistics events end‑to‑end from order placement to final delivery. The entities and their relationships are structured to support core operations such as product catalog management, inventory visibility at each warehouse, shipment assignment to drivers, order tracking across multiple legs, and analytics on fulfillment performance and service levels.

---
<img width="1224" height="634" alt="image" src="https://github.com/DilipBaduwal/Udaan_B2B_Group9_Sec_C/blob/main/image.png?raw=true" />


## Project Overview

This system ensures seamless coordination between:
- **Customer**
- **Supplier**
- **Warehouse**
- **Driver**
- **SKU**
- **Product**
- **Orders**
- **Logistics**


It provides accurate tracking of supplier listings, product assortments, shipments, pricing, and retailer order fulfillment across the Udaan network.

---

## Relationships References 

| Module | Dependencies | Insert after |
|--------|--------------|--------------|
| customer_data | `None`| `First` |
| product | `None`| `After customer_data` |
| sku | `product(product_id)`| `After sku` |
| warehouse | `sku(sku_id)`|`After sku` |
| driver_detail | `warehouse(warehouse_id)`|`After warehouse` |
| placed_orders | `customer_data(customer_id)`, ` sku(sku_id)`| `After customer_data`, `sku` |
| supplier | `sku(product_id)`, `warehouse(warehouse_id)` , `sku(sku_id)` | `After sku`,`warehouse`|
| logistic | `placed_orders(order_id)`, `warehouse` , `driver_detail`  | `After placed_orders`,`warehouse`,`driver_detail`|

---

## Supply Chain Flow

```mermaid
flowchart TD
    A[customer_data] --> B[product]
    B --> C[sku]
    C --> D[warehouse]
    D --> E[driver_detail]
    A --> F[placed_orders]
    C --> F[placed_orders]
    C --> G[supplier]
    D --> G[supplier]
    F --> H[logistic]
    D --> H[logistic]
    E --> H[logistic]
