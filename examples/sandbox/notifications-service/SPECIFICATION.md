# Notifications Service Specification

## Overview
This is a sandbox example of the Notifications Service specification created with speckit-central.

## Service Purpose
The Notifications Service handles sending notifications (email, SMS, push) to users across the platform.

## API Endpoints

### Send Notification
- **Endpoint**: `POST /api/v1/notifications`
- **Description**: Send a notification
- **Request Body**:
  ```json
  {
    "userId": "string",
    "type": "email|sms|push",
    "template": "string",
    "data": {
      "key": "value"
    }
  }
  ```
- **Response**: `202 Accepted`

### Get Notification History
- **Endpoint**: `GET /api/v1/notifications`
- **Description**: Get notification history for a user
- **Query Parameters**: `userId`, `type`, `limit`, `offset`
- **Response**: `200 OK`

### Mark as Read
- **Endpoint**: `PATCH /api/v1/notifications/{notificationId}/read`
- **Description**: Mark notification as read
- **Response**: `200 OK`

## Event Subscriptions
- OrderCreated
- OrderShipped
- PaymentReceived
- UserRegistered
- PasswordReset

## Templates
- order-confirmation
- order-shipped
- payment-confirmation
- password-reset
- account-notification

## Data Models

### Notification
```
- notificationId: string (UUID)
- userId: string
- type: NotificationType
- template: string
- status: NotificationStatus
- createdAt: timestamp
- sentAt: timestamp
- readAt: timestamp (nullable)
```

### NotificationType
- EMAIL
- SMS
- PUSH

### NotificationStatus
- PENDING
- SENT
- FAILED
- BOUNCED

## Technology Stack
- Language: Node.js with TypeScript
- Framework: Express.js
- Message Queue: RabbitMQ
- Email Service: SendGrid
- SMS Service: Twilio
- Database: MongoDB
- Cache: Redis

