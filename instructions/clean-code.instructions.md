# Clean Code and SOLID Principles for Java

**Applies to**: `*.java` files

## Core Clean Code Principles

- **Single Responsibility**: Each module/class/function should have one reason to change
- **Small Units**: Keep functions, classes, and files small and focused
- **DRY (Don't Repeat Yourself)**: Eliminate code duplication
- **YAGNI (You Aren't Gonna Need It)**: Don't add functionality until it's needed
- **Low Coupling, High Cohesion**: Minimize dependencies between modules

## SOLID Principles

### Single Responsibility Principle (SRP)
*A class should have only one reason to change*

```java
// ❌ Bad: Multiple responsibilities
@Service
public class UserService {
    public User createUser(CreateUserDto data) {
        // Validate user data
        if (!data.getEmail().contains("@")) {
            throw new IllegalArgumentException("Invalid email");
        }

        // Save to database
        User user = userRepository.save(new User(data));

        // Send email
        restTemplate.postForEntity("/api/email", 
            Map.of("to", data.getEmail(), "template", "welcome"), 
            String.class);

        // Log analytics
        restTemplate.postForEntity("/api/analytics", 
            Map.of("event", "user_created"), 
            String.class);

        return user;
    }
}

// ✅ Good: Single responsibility per class
@Component
public class UserValidator {
    public ValidationResult validate(CreateUserDto data) {
        if (!data.getEmail().contains("@")) {
            return new ValidationResult(false, List.of("Invalid email"));
        }
        return new ValidationResult(true, List.of());
    }
}

@Repository
public class UserRepository {
    public User create(CreateUserDto data) {
        return entityManager.persist(new User(data));
    }
}

@Service
public class EmailService {
    public void sendWelcomeEmail(String email) {
        // Email sending logic
    }
}

@Service
public class AnalyticsService {
    public void trackEvent(String event) {
        // Analytics tracking logic
    }
}

@Service
public class UserService {
    private final UserValidator validator;
    private final UserRepository repository;
    private final EmailService emailService;
    private final AnalyticsService analytics;

    public UserService(UserValidator validator, UserRepository repository, 
                      EmailService emailService, AnalyticsService analytics) {
        this.validator = validator;
        this.repository = repository;
        this.emailService = emailService;
        this.analytics = analytics;
    }

    public User createUser(CreateUserDto data) {
        ValidationResult validation = validator.validate(data);
        if (!validation.isValid()) {
            throw new ValidationException(validation.getErrors());
        }

        User user = repository.create(data);
        emailService.sendWelcomeEmail(user.getEmail());
        analytics.trackEvent("user_created");

        return user;
    }
}
```

### Open/Closed Principle (OCP)
*Open for extension, closed for modification*

```java
// ❌ Bad: Must modify class to add new payment methods
public class PaymentProcessor {
    public void processPayment(BigDecimal amount, String method) {
        if (method.equals("credit_card")) {
            // Process credit card
        } else if (method.equals("paypal")) {
            // Process PayPal
        } else if (method.equals("crypto")) {
            // Process crypto
        }
        // Adding new method requires modifying this class
    }
}

// ✅ Good: Extend without modifying
public interface PaymentMethod {
    PaymentResult process(BigDecimal amount);
}

@Component
public class CreditCardPayment implements PaymentMethod {
    @Override
    public PaymentResult process(BigDecimal amount) {
        // Credit card specific logic
        return new PaymentResult(true, "123");
    }
}

@Component
public class PayPalPayment implements PaymentMethod {
    @Override
    public PaymentResult process(BigDecimal amount) {
        // PayPal specific logic
        return new PaymentResult(true, "456");
    }
}

@Component
public class CryptoPayment implements PaymentMethod {
    @Override
    public PaymentResult process(BigDecimal amount) {
        // Crypto specific logic
        return new PaymentResult(true, "789");
    }
}

@Service
public class PaymentProcessor {
    public PaymentResult processPayment(BigDecimal amount, PaymentMethod paymentMethod) {
        return paymentMethod.process(amount);
    }
}

// Usage - no modification needed for new payment methods
PaymentProcessor processor = new PaymentProcessor();
processor.processPayment(new BigDecimal("100"), new CreditCardPayment());
processor.processPayment(new BigDecimal("100"), new PayPalPayment());
```

### Liskov Substitution Principle (LSP)
*Subtypes must be substitutable for their base types*

```java
// ❌ Bad: Violates LSP
public class Bird {
    public void fly() {
        System.out.println("Flying");
    }
}

public class Penguin extends Bird {
    @Override
    public void fly() {
        throw new UnsupportedOperationException("Penguins cannot fly!"); // Breaks expectations
    }
}

// ✅ Good: Respect base type behavior
public interface Bird {
    void move();
}

public class FlyingBird implements Bird {
    public void fly() {
        System.out.println("Flying");
    }

    @Override
    public void move() {
        fly();
    }
}

public class Penguin implements Bird {
    public void swim() {
        System.out.println("Swimming");
    }

    @Override
    public void move() {
        swim();
    }
}

// Both can be used interchangeably
public void makeBirdMove(Bird bird) {
    bird.move(); // Works for all birds
}
```

### Interface Segregation Principle (ISP)
*Clients shouldn't depend on interfaces they don't use*

```java
// ❌ Bad: Fat interface
public interface Worker {
    void work();
    void eat();
    void sleep();
    void writeCode();
    void attendMeetings();
}

public class Developer implements Worker {
    @Override
    public void work() { /* implement */ }
    
    @Override
    public void eat() { /* implement */ }
    
    @Override
    public void sleep() { /* implement */ }
    
    @Override
    public void writeCode() { /* implement */ }
    
    @Override
    public void attendMeetings() { /* implement */ }
}

public class Robot implements Worker {
    @Override
    public void work() { /* implement */ }
    
    @Override
    public void eat() { 
        throw new UnsupportedOperationException("Robots do not eat"); // Forced to implement
    }
    
    @Override
    public void sleep() { 
        throw new UnsupportedOperationException("Robots do not sleep"); // Forced to implement
    }
    
    @Override
    public void writeCode() { /* implement */ }
    
    @Override
    public void attendMeetings() { /* implement */ }
}

// ✅ Good: Segregated interfaces
public interface Workable {
    void work();
}

public interface Eatable {
    void eat();
}

public interface Sleepable {
    void sleep();
}

public interface Codeable {
    void writeCode();
}

public class Developer implements Workable, Eatable, Sleepable, Codeable {
    @Override
    public void work() { /* implement */ }
    
    @Override
    public void eat() { /* implement */ }
    
    @Override
    public void sleep() { /* implement */ }
    
    @Override
    public void writeCode() { /* implement */ }
}

public class Robot implements Workable, Codeable {
    @Override
    public void work() { /* implement */ }
    
    @Override
    public void writeCode() { /* implement */ }
    // No need to implement eat() or sleep()
}
```

### Dependency Inversion Principle (DIP)
*Depend on abstractions, not concretions*

```java
// ❌ Bad: High-level module depends on low-level module
public class MySQLDatabase {
    public void save(Object data) {
        // MySQL specific code
    }
}

public class UserService {
    private MySQLDatabase db = new MySQLDatabase(); // Tightly coupled

    public void saveUser(User user) {
        db.save(user);
    }
}

// ✅ Good: Both depend on abstraction
public interface Database {
    void save(Object data);
    Optional<Object> find(String id);
}

@Component
public class MySQLDatabase implements Database {
    @Override
    public void save(Object data) {
        // MySQL specific code
    }

    @Override
    public Optional<Object> find(String id) {
        // MySQL specific code
        return Optional.empty();
    }
}

@Component
public class PostgreSQLDatabase implements Database {
    @Override
    public void save(Object data) {
        // PostgreSQL specific code
    }

    @Override
    public Optional<Object> find(String id) {
        // PostgreSQL specific code
        return Optional.empty();
    }
}

@Service
public class UserService {
    private final Database database; // Depends on abstraction

    public UserService(Database database) {
        this.database = database;
    }

    public void saveUser(User user) {
        database.save(user);
    }
}

// Usage - easily switch implementations via dependency injection
@Configuration
public class AppConfig {
    @Bean
    public Database database() {
        return new MySQLDatabase();
        // or return new PostgreSQLDatabase();
    }
}
```

## File Organization and Size

### Keep Files Small and Focused

```java
// ❌ Bad: One massive file (1000+ lines)
// UserService.java
public class UserService { /* 500 lines */ }
class UserValidator { /* 200 lines */ }
class UserRepository { /* 300 lines */ }
interface User { /* ... */ }
interface CreateUserDto { /* ... */ }
// ... more code

// ✅ Good: Separate focused files
// src/main/java/com/example/user/domain/User.java
package com.example.user.domain;

public class User {
    private String id;
    private String email;
    private String name;
    
    // Constructor, getters, setters
}

// src/main/java/com/example/user/dto/CreateUserDto.java
package com.example.user.dto;

public class CreateUserDto {
    private String email;
    private String name;
    private String password;
    
    // Constructor, getters, setters
}

// src/main/java/com/example/user/validator/UserValidator.java
package com.example.user.validator;

@Component
public class UserValidator {
    public ValidationResult validate(CreateUserDto data) {
        // ~50 lines
    }
}

// src/main/java/com/example/user/repository/UserRepository.java
package com.example.user.repository;

@Repository
public interface UserRepository extends JpaRepository<User, String> {
    Optional<User> findByEmail(String email);
}

// src/main/java/com/example/user/service/UserService.java
package com.example.user.service;

@Service
public class UserService {
    private final UserValidator validator;
    private final UserRepository repository;

    public UserService(UserValidator validator, UserRepository repository) {
        this.validator = validator;
        this.repository = repository;
    }

    public User createUser(CreateUserDto data) {
        // ~40 lines
    }
}
```

### Recommended File Sizes

```java
// Guidelines:
// - Maximum 300 lines per file (prefer < 200)
// - Maximum 50 lines per method (prefer < 20)
// - Maximum 10 methods per class
// - If file exceeds limits, split into multiple files
```

## Function Size and Complexity

### Keep Functions Small

```java
// ❌ Bad: Large method doing too much (complexity > 5)
public void processOrder(Order order) throws Exception {
    // Validate order (10 lines)
    if (order.getItems() == null || order.getItems().isEmpty()) {
        throw new IllegalArgumentException("Order must have items");
    }
    for (OrderItem item : order.getItems()) {
        if (item.getQuantity() <= 0) {
            throw new IllegalArgumentException("Invalid quantity");
        }
    }

    // Calculate totals (15 lines)
    BigDecimal subtotal = BigDecimal.ZERO;
    for (OrderItem item : order.getItems()) {
        subtotal = subtotal.add(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
    }
    BigDecimal tax = subtotal.multiply(new BigDecimal("0.1"));
    BigDecimal shipping = subtotal.compareTo(new BigDecimal("100")) > 0 ? BigDecimal.ZERO : new BigDecimal("10");
    BigDecimal total = subtotal.add(tax).add(shipping);

    // Check inventory (20 lines)
    for (OrderItem item : order.getItems()) {
        int stock = checkInventory(item.getProductId());
        if (stock < item.getQuantity()) {
            throw new IllegalStateException("Insufficient stock");
        }
    }

    // Process payment (15 lines)
    PaymentResult paymentResult = processPayment(total, order.getPaymentMethod());
    if (!paymentResult.isSuccess()) {
        throw new PaymentException("Payment failed");
    }

    // Update inventory (10 lines)
    for (OrderItem item : order.getItems()) {
        updateInventory(item.getProductId(), -item.getQuantity());
    }

    // Send notifications (10 lines)
    sendEmail(order.getCustomerEmail(), "Order confirmed");
    sendSMS(order.getCustomerPhone(), "Order confirmed");

    // ... more code
}

// ✅ Good: Small, focused methods (complexity ≤ 5 each)
public void processOrder(Order order) throws Exception {
    validateOrder(order);
    OrderPricing pricing = calculateOrderPricing(order);
    verifyInventoryAvailability(order);
    processOrderPayment(order, pricing.getTotal());
    updateOrderInventory(order);
    sendOrderNotifications(order);
}

private void validateOrder(Order order) {
    if (order.getItems() == null || order.getItems().isEmpty()) {
        throw new IllegalArgumentException("Order must have items");
    }

    for (OrderItem item : order.getItems()) {
        validateOrderItem(item);
    }
}

private void validateOrderItem(OrderItem item) {
    if (item.getQuantity() <= 0) {
        throw new IllegalArgumentException("Invalid quantity");
    }
}

private OrderPricing calculateOrderPricing(Order order) {
    BigDecimal subtotal = calculateSubtotal(order.getItems());
    BigDecimal tax = calculateTax(subtotal);
    BigDecimal shipping = calculateShipping(subtotal);
    BigDecimal total = subtotal.add(tax).add(shipping);

    return new OrderPricing(subtotal, tax, shipping, total);
}

private BigDecimal calculateSubtotal(List<OrderItem> items) {
    return items.stream()
            .map(item -> item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
}

private void verifyInventoryAvailability(Order order) throws Exception {
    for (OrderItem item : order.getItems()) {
        verifyItemInventory(item);
    }
}

private void verifyItemInventory(OrderItem item) throws Exception {
    int stock = checkInventory(item.getProductId());
    if (stock < item.getQuantity()) {
        throw new IllegalStateException("Insufficient stock for " + item.getProductId());
    }
}
```

## Class Size and Responsibility

### Keep Classes Small

```java
// ❌ Bad: God class (500+ lines, multiple responsibilities)
public class OrderManager {
    public void validateOrder() { /* ... */ }
    public void calculatePricing() { /* ... */ }
    public void processPayment() { /* ... */ }
    public void updateInventory() { /* ... */ }
    public void sendNotifications() { /* ... */ }
    public void generateInvoice() { /* ... */ }
    public void trackShipment() { /* ... */ }
    public void handleReturns() { /* ... */ }
    // ... 20+ more methods
}

// ✅ Good: Small, focused classes
@Component
public class OrderValidator {
    public ValidationResult validate(Order order) {
        // Single responsibility: validation
    }
}

@Component
public class OrderPricingCalculator {
    public OrderPricing calculate(Order order) {
        // Single responsibility: pricing
    }
}

@Service
public class OrderPaymentProcessor {
    public PaymentResult process(Order order, BigDecimal amount) {
        // Single responsibility: payment
    }
}

@Service
public class OrderInventoryManager {
    public void reserve(Order order) {
        // Single responsibility: inventory
    }
}

@Service
public class OrderNotificationService {
    public void notify(Order order) {
        // Single responsibility: notifications
    }
}

// Orchestrator brings them together
@Service
public class OrderService {
    private final OrderValidator validator;
    private final OrderPricingCalculator calculator;
    private final OrderPaymentProcessor paymentProcessor;
    private final OrderInventoryManager inventoryManager;
    private final OrderNotificationService notificationService;

    public OrderService(
            OrderValidator validator,
            OrderPricingCalculator calculator,
            OrderPaymentProcessor paymentProcessor,
            OrderInventoryManager inventoryManager,
            OrderNotificationService notificationService) {
        this.validator = validator;
        this.calculator = calculator;
        this.paymentProcessor = paymentProcessor;
        this.inventoryManager = inventoryManager;
        this.notificationService = notificationService;
    }

    public void processOrder(Order order) {
        validator.validate(order);
        OrderPricing pricing = calculator.calculate(order);
        paymentProcessor.process(order, pricing.getTotal());
        inventoryManager.reserve(order);
        notificationService.notify(order);
    }
}
```

## Module Organization

### Organize by Feature, Not Type

```java
// ❌ Bad: Organized by technical type
src/main/java/com/example/
├── controller/
│   ├── UserController.java
│   ├── OrderController.java
│   └── ProductController.java
├── service/
│   ├── UserService.java
│   ├── OrderService.java
│   └── ProductService.java
├── repository/
│   ├── UserRepository.java
│   ├── OrderRepository.java
│   └── ProductRepository.java
└── domain/
    ├── User.java
    ├── Order.java
    └── Product.java

// ✅ Good: Organized by feature/domain
src/main/java/com/example/
├── user/
│   ├── User.java
│   ├── UserService.java
│   ├── UserRepository.java
│   ├── UserController.java
│   ├── UserValidator.java
│   └── dto/
│       ├── CreateUserDto.java
│       └── UpdateUserDto.java
├── order/
│   ├── Order.java
│   ├── OrderService.java
│   ├── OrderRepository.java
│   ├── OrderController.java
│   └── dto/
│       └── CreateOrderDto.java
└── product/
    ├── Product.java
    ├── ProductService.java
    ├── ProductRepository.java
    └── ProductController.java
```

## DRY Principle

### Eliminate Duplication

```java
// ❌ Bad: Repeated code
public User createUser(CreateUserDto data) {
    if (data.getEmail() == null || data.getEmail().isEmpty()) {
        throw new IllegalArgumentException("Email is required");
    }
    if (data.getName() == null || data.getName().isEmpty()) {
        throw new IllegalArgumentException("Name is required");
    }
    if (data.getPassword() == null || data.getPassword().isEmpty()) {
        throw new IllegalArgumentException("Password is required");
    }
    // ... save user
}

public User updateUser(String id, UpdateUserDto data) {
    if (data.getEmail() == null || data.getEmail().isEmpty()) {
        throw new IllegalArgumentException("Email is required");
    }
    if (data.getName() == null || data.getName().isEmpty()) {
        throw new IllegalArgumentException("Name is required");
    }
    // ... update user
}

// ✅ Good: Extract common logic
private void validateRequiredFields(Map<String, String> fieldsToValidate) {
    for (Map.Entry<String, String> entry : fieldsToValidate.entrySet()) {
        if (entry.getValue() == null || entry.getValue().isEmpty()) {
            throw new IllegalArgumentException(entry.getKey() + " is required");
        }
    }
}

public User createUser(CreateUserDto data) {
    Map<String, String> fields = Map.of(
        "Email", data.getEmail(),
        "Name", data.getName(),
        "Password", data.getPassword()
    );
    validateRequiredFields(fields);
    // ... save user
}

public User updateUser(String id, UpdateUserDto data) {
    Map<String, String> fields = Map.of(
        "Email", data.getEmail(),
        "Name", data.getName()
    );
    validateRequiredFields(fields);
    // ... update user
}
```

## Composition Over Inheritance

```java
// ❌ Bad: Deep inheritance hierarchy
class Animal {
    void eat() { /* ... */ }
}

class Mammal extends Animal {
    void breathe() { /* ... */ }
}

class Dog extends Mammal {
    void bark() { /* ... */ }
}

class SwimmingDog extends Dog {
    void swim() { /* ... */ }
}

// ✅ Good: Composition
interface Eatable {
    void eat();
}

interface Breathable {
    void breathe();
}

interface Barkable {
    void bark();
}

interface Swimmable {
    void swim();
}

class Dog implements Eatable, Breathable, Barkable {
    @Override
    public void eat() { /* ... */ }
    
    @Override
    public void breathe() { /* ... */ }
    
    @Override
    public void bark() { /* ... */ }
}

class SwimmingDog implements Eatable, Breathable, Barkable, Swimmable {
    @Override
    public void eat() { /* ... */ }
    
    @Override
    public void breathe() { /* ... */ }
    
    @Override
    public void bark() { /* ... */ }
    
    @Override
    public void swim() { /* ... */ }
}
```

## Law of Demeter (Principle of Least Knowledge)

```java
// ❌ Bad: Violates Law of Demeter
class Order {
    private Customer customer;
    
    public Customer getCustomer() {
        return customer;
    }
}

class Customer {
    private Address address;
    
    public Address getAddress() {
        return address;
    }
}

class Address {
    private String city;
    
    public String getCity() {
        return city;
    }
}

String getOrderCity(Order order) {
    return order.getCustomer().getAddress().getCity(); // Too much knowledge of structure
}

// ✅ Good: Tell, don't ask
class Order {
    private Customer customer;

    public Order(Customer customer) {
        this.customer = customer;
    }

    public String getCustomerCity() {
        return customer.getCity();
    }
}

class Customer {
    private Address address;

    public Customer(Address address) {
        this.address = address;
    }

    public String getCity() {
        return address.getCity();
    }
}

class Address {
    private String city;

    public Address(String city) {
        this.city = city;
    }

    public String getCity() {
        return city;
    }
}

String getOrderCity(Order order) {
    return order.getCustomerCity(); // Only knows about order
}
```

## Clean Code Checklist

- [ ] Each function does one thing and does it well
- [ ] Functions are small (< 20 lines preferred, < 50 max)
- [ ] Files are small (< 200 lines preferred, < 300 max)
- [ ] Classes have single responsibility
- [ ] No code duplication
- [ ] Intention-revealing names
- [ ] No magic numbers or strings
- [ ] Proper error handling
- [ ] Functions have maximum 3 parameters (use objects for more)
- [ ] Cyclomatic complexity ≤ 5
- [ ] Dependencies are injected
- [ ] Code is testable
- [ ] No side effects in pure functions
- [ ] Immutability where possible
