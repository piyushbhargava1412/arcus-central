# Orders Service Specification

## Overview
This is a sandbox example demonstrating a typical microservice specification created with APEX Central (SDD framework).

## Service Purpose
The Orders Service handles order creation, tracking, and management for the e-commerce platform.

## API Endpoints

### Create Order
- **Endpoint**: `POST /api/v1/orders`
- **Description**: Create a new order
- **Request Body**:
  ```json
  {
    "customerId": "string",
    "items": [
      {
        "productId": "string",
        "quantity": number,
        "price": number
      }
    ],
    "shippingAddress": {
      "street": "string",
      "city": "string",
      "state": "string",
      "zipCode": "string"
    }
  }
  ```
- **Response**: `201 Created`

### Get Order
- **Endpoint**: `GET /api/v1/orders/{orderId}`
- **Description**: Retrieve order details
- **Response**: `200 OK`

### List Orders
- **Endpoint**: `GET /api/v1/orders`
- **Description**: List orders for a customer
- **Query Parameters**: `customerId`, `limit`, `offset`
- **Response**: `200 OK`

### Cancel Order
- **Endpoint**: `DELETE /api/v1/orders/{orderId}`
- **Description**: Cancel an order
- **Response**: `204 No Content`

## Data Models

### Order
```
- orderId: string (UUID)
- customerId: string
- items: OrderItem[]
- status: OrderStatus
- totalAmount: number
- createdAt: timestamp
- updatedAt: timestamp
```

### OrderStatus
- PENDING
- PROCESSING
- SHIPPED
- DELIVERED
- CANCELLED

## Dependencies
- Inventory Service
- Payment Service
- Notification Service

## Technology Stack
- Language: Node.js with TypeScript
- Framework: Express.js
- Database: PostgreSQL
- Message Queue: RabbitMQ
- Container: Docker

