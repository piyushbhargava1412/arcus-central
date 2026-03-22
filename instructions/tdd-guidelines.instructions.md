# Test-Driven Development (TDD) Guidelines

**Applies to**: All `*.java` files

## Core TDD Principles

- **Red-Green-Refactor**: Write failing test → Make it pass → Refactor
- **Test First**: Always write the test before writing implementation code
- **Incremental Development**: Build functionality one small test at a time
- **Minimal Implementation**: Write only enough code to make the test pass
- **Comprehensive Coverage**: Aim for 80%+ code coverage on new code

## The TDD Cycle

### 1. Red Phase: Write a Failing Test

```java
// ❌ Don't: Write implementation first
public class DiscountCalculator {
    public BigDecimal calculateDiscount(BigDecimal price, int percentage) {
        return price.multiply(BigDecimal.valueOf(percentage))
                   .divide(BigDecimal.valueOf(100));
    }
}

// ✅ Do: Write test first (it will fail)
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class DiscountCalculatorTest {
    
    @Test
    void shouldCalculate10PercentDiscountOn100() {
        DiscountCalculator calculator = new DiscountCalculator();
        BigDecimal result = calculator.calculateDiscount(new BigDecimal("100"), 10);
        assertEquals(new BigDecimal("10.00"), result);
    }
}

// Run test → RED (class/method doesn't exist yet)
```

### 2. Green Phase: Write Minimal Code to Pass

```java
// ✅ Write simplest implementation to make test pass
public class DiscountCalculator {
    public BigDecimal calculateDiscount(BigDecimal price, int percentage) {
        return price.multiply(BigDecimal.valueOf(percentage))
                   .divide(BigDecimal.valueOf(100), RoundingMode.HALF_UP);
    }
}

// Run test → GREEN (test passes)
```

### 3. Refactor Phase: Improve Code Quality

```java
// ✅ Refactor while keeping tests green
public class DiscountCalculator {
    public BigDecimal calculateDiscount(BigDecimal price, int percentage) {
        validateInputs(price, percentage);
        return price.multiply(BigDecimal.valueOf(percentage))
                   .divide(BigDecimal.valueOf(100), RoundingMode.HALF_UP);
    }

    private void validateInputs(BigDecimal price, int percentage) {
        if (price.compareTo(BigDecimal.ZERO) < 0 || percentage < 0 || percentage > 100) {
            throw new IllegalArgumentException("Invalid input");
        }
    }
}

// Run test → GREEN (still passes after refactoring)
```

## TDD Workflow Example

### Step 1: Write First Test

```java
// UserServiceTest.java
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class UserServiceTest {
    
    private UserService userService;
    
    @Mock
    private UserRepository mockRepository;
    
    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        userService = new UserService(mockRepository);
    }
    
    @Test
    void shouldCreateUserWithValidData() {
        // Arrange
        CreateUserDto userData = new CreateUserDto("test@example.com", "Test User");
        User expectedUser = new User("1", "test@example.com", "Test User");
        
        when(mockRepository.save(any(User.class))).thenReturn(expectedUser);
        
        // Act
        User result = userService.createUser(userData);
        
        // Assert
        assertEquals(expectedUser, result);
        verify(mockRepository).save(any(User.class));
    }
}

// Run → RED (UserService doesn't exist)
```

### Step 2: Minimal Implementation

```java
// UserService.java
@Service
public class UserService {
    private final UserRepository repository;

    public UserService(UserRepository repository) {
        this.repository = repository;
    }

    public User createUser(CreateUserDto userData) {
        User user = new User(null, userData.getEmail(), userData.getName());
        return repository.save(user);
    }
}

// Run → GREEN
```

### Step 3: Add More Tests

```java
// UserServiceTest.java
class UserServiceTest {
    // ...existing setup...

    @Test
    void shouldThrowErrorWhenEmailIsInvalid() {
        CreateUserDto userData = new CreateUserDto("invalid-email", "Test User");
        
        IllegalArgumentException exception = assertThrows(
            IllegalArgumentException.class,
            () -> userService.createUser(userData)
        );
        
        assertEquals("Invalid email format", exception.getMessage());
    }
    
    // Run → RED (no validation yet)
}
```

### Step 4: Implement to Pass New Test

```java
// UserService.java
@Service
public class UserService {
    private final UserRepository repository;

    public UserService(UserRepository repository) {
        this.repository = repository;
    }

    public User createUser(CreateUserDto userData) {
        validateEmail(userData.getEmail());
        User user = new User(null, userData.getEmail(), userData.getName());
        return repository.save(user);
    }

    private void validateEmail(String email) {
        if (!email.contains("@")) {
            throw new IllegalArgumentException("Invalid email format");
        }
    }
}

// Run → GREEN
```

### Step 5: Refactor

```java
// UserService.java
@Service
public class UserService {
    private final UserRepository repository;
    private final UserValidator validator;

    public UserService(UserRepository repository, UserValidator validator) {
        this.repository = repository;
        this.validator = validator;
    }

    public User createUser(CreateUserDto userData) {
        validator.validate(userData);
        User user = new User(null, userData.getEmail(), userData.getName());
        return repository.save(user);
    }
}

// UserValidator.java
@Component
public class UserValidator {
    public void validate(CreateUserDto userData) {
        validateEmail(userData.getEmail());
        validateName(userData.getName());
    }

    private void validateEmail(String email) {
        if (email == null || !email.contains("@")) {
            throw new IllegalArgumentException("Invalid email format");
        }
    }

    private void validateName(String name) {
        if (name == null || name.length() < 2) {
            throw new IllegalArgumentException("Invalid name");
        }
    }
}

// Run → GREEN (tests still pass)
```

## Test Structure

### AAA Pattern: Arrange, Act, Assert

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class OrderServiceTest {
    
    @Test
    void shouldCalculateOrderTotalWithTax() {
        // Arrange - Set up test data and dependencies
        List<OrderItem> orderItems = List.of(
            new OrderItem("1", new BigDecimal("10"), 2),
            new OrderItem("2", new BigDecimal("5"), 3)
        );
        OrderService orderService = new OrderService();

        // Act - Execute the function being tested
        BigDecimal result = orderService.calculateTotal(orderItems);

        // Assert - Verify the result
        assertEquals(new BigDecimal("38.50"), result); // (10*2 + 5*3) * 1.1 (10% tax)
    }
}
```

### Given-When-Then Pattern

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class CartServiceTest {
    
    @Test
    void shouldAddItemToCart() {
        // Given - Initial state
        Cart cart = new Cart();
        Item item = new Item("1", "Product", new BigDecimal("10"));

        // When - Action occurs
        cart.addItem(item);

        // Then - Expected outcome
        assertEquals(1, cart.getItems().size());
        assertEquals(item, cart.getItems().get(0));
    }
}
```

## Testing Best Practices

### Write Tests for All Cases

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class DiscountCalculatorTest {
    
    // Happy path
    @Test
    void shouldCalculateDiscountForValidInputs() {
        BigDecimal result = calculateDiscount(new BigDecimal("100"), 10);
        assertEquals(new BigDecimal("10.00"), result);
    }

    // Edge cases
    @Test
    void shouldReturn0For0PercentDiscount() {
        BigDecimal result = calculateDiscount(new BigDecimal("100"), 0);
        assertEquals(new BigDecimal("0.00"), result);
    }

    @Test
    void shouldHandle100PercentDiscount() {
        BigDecimal result = calculateDiscount(new BigDecimal("100"), 100);
        assertEquals(new BigDecimal("100.00"), result);
    }

    // Error cases
    @Test
    void shouldThrowErrorForNegativePrice() {
        IllegalArgumentException exception = assertThrows(
            IllegalArgumentException.class,
            () -> calculateDiscount(new BigDecimal("-100"), 10)
        );
        assertEquals("Invalid input", exception.getMessage());
    }

    @Test
    void shouldThrowErrorForInvalidPercentage() {
        IllegalArgumentException exception = assertThrows(
            IllegalArgumentException.class,
            () -> calculateDiscount(new BigDecimal("100"), 150)
        );
        assertEquals("Invalid input", exception.getMessage());
    }
}
```

### Use Descriptive Test Names

```java
// ❌ Bad: Vague test names
@Test
void works() { }

@Test
void test1() { }

@Test
void returnsValue() { }

// ✅ Good: Descriptive test names
@Test
void shouldReturnEmptyListWhenNoUsersExist() { }

@Test
void shouldThrowErrorWhenUserIdIsInvalid() { }

@Test
void shouldSuccessfullyCreateUserWithValidEmail() { }

@Test
void shouldCalculateTotalWith10PercentTaxForMultipleItems() { }
```

### One Assertion per Test (When Possible)

```java
// ❌ Bad: Testing multiple things
@Test
void shouldProcessOrder() {
    Order order = orderService.processOrder(orderData);
    assertEquals("processed", order.getStatus());
    assertEquals(new BigDecimal("100"), order.getTotal());
    assertEquals(3, order.getItems().size());
    verify(mockPaymentService).process(any());
    verify(mockEmailService).send(any());
}

// ✅ Good: Separate focused tests
class ProcessOrderTest {
    
    @Test
    void shouldSetStatusToProcessed() {
        Order order = orderService.processOrder(orderData);
        assertEquals("processed", order.getStatus());
    }

    @Test
    void shouldCalculateCorrectTotal() {
        Order order = orderService.processOrder(orderData);
        assertEquals(new BigDecimal("100"), order.getTotal());
    }

    @Test
    void shouldCallPaymentService() {
        orderService.processOrder(orderData);
        verify(mockPaymentService).process(orderData);
    }

    @Test
    void shouldSendConfirmationEmail() {
        orderService.processOrder(orderData);
        verify(mockEmailService).send(any());
    }
}
```

## Mocking and Test Doubles

### Use Dependency Injection for Testability

```java
// ✅ Testable design with DI
@Service
public class UserService {
    private final UserRepository repository;
    private final EmailService emailService;
    private final Logger logger;

    public UserService(
            UserRepository repository,
            EmailService emailService,
            Logger logger) {
        this.repository = repository;
        this.emailService = emailService;
        this.logger = logger;
    }

    public User createUser(CreateUserDto data) {
        User user = repository.save(data);
        emailService.sendWelcome(user.getEmail());
        logger.info("User created: {}", user.getId());
        return user;
    }
}

// Easy to test with mocks
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    @Mock
    private UserRepository mockRepository;
    
    @Mock
    private EmailService mockEmailService;
    
    @Mock
    private Logger mockLogger;
    
    @InjectMocks
    private UserService userService;
    
    @Test
    void shouldCreateUser() {
        // Test implementation
    }
}
```

### Mock External Dependencies

```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

class WeatherServiceTest {
    
    @Mock
    private RestTemplate mockRestTemplate;
    
    private WeatherService weatherService;
    
    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        weatherService = new WeatherService(mockRestTemplate);
    }
    
    @Test
    void shouldFetchWeatherData() {
        // Arrange
        String city = "Seattle";
        WeatherData mockWeatherData = new WeatherData(72, "sunny");
        
        when(mockRestTemplate.getForObject(
            contains(city),
            eq(WeatherData.class)
        )).thenReturn(mockWeatherData);
        
        // Act
        WeatherData result = weatherService.getWeather(city);
        
        // Assert
        assertEquals(mockWeatherData, result);
        verify(mockRestTemplate).getForObject(
            contains(city),
            eq(WeatherData.class)
        );
    }
}
```

## Test Coverage Goals

### Aim for High Coverage

```java
// Coverage targets:
// - Line coverage: 80%+
// - Branch coverage: 75%+
// - Method coverage: 90%+

// Run coverage report with Gradle
// ./gradlew test jacocoTestReport

// Run coverage report with Maven
// mvn clean test jacoco:report

// View coverage report
// open build/reports/jacoco/test/html/index.html (Gradle)
// open target/site/jacoco/index.html (Maven)
```

### Focus on Critical Paths

```java
// ✅ Prioritize testing:
// 1. Business logic
// 2. Error handling
// 3. Edge cases
// 4. Integration points
// 5. Public APIs

// ⚠️ Less critical (but still test):
// - Simple getters/setters
// - Pure data transformations
// - Generated code
// - Configuration classes
```

## Integration Testing with TDD

```java
// Integration test example with Spring Boot
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.jdbc.Sql;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Sql(scripts = "/cleanup.sql", executionPhase = Sql.ExecutionPhase.AFTER_TEST_METHOD)
class UserRegistrationFlowTest {
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Autowired
    private UserRepository userRepository;
    
    @Test
    void shouldRegisterNewUserAndSendWelcomeEmail() {
        // Arrange
        CreateUserDto userData = new CreateUserDto(
            "newuser@example.com",
            "New User",
            "securePassword123"
        );
        
        // Act
        ResponseEntity<User> response = restTemplate.postForEntity(
            "/api/users/register",
            userData,
            User.class
        );
        
        // Assert
        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertNotNull(response.getBody());
        assertNotNull(response.getBody().getId());
        assertEquals(userData.getEmail(), response.getBody().getEmail());
        
        // Verify user exists in database
        Optional<User> savedUser = userRepository.findByEmail(userData.getEmail());
        assertTrue(savedUser.isPresent());
        assertEquals(userData.getName(), savedUser.get().getName());
    }
}
```

## TDD Anti-Patterns to Avoid

### Don't Write Tests After Implementation

```java
// ❌ Bad: Tests written after code is done
// 1. Write all implementation
// 2. Then write tests to match existing code
// Result: Tests that just confirm what code does, not what it should do

// ✅ Good: Tests drive implementation
// 1. Write test for desired behavior
// 2. Implement just enough to pass
// 3. Refactor
// 4. Repeat
```

### Don't Skip Refactoring

```java
// ❌ Bad: Move to next feature without refactoring
@Test
void shouldDoSomething() {
    // Write test
}

// Make test pass with messy code
// Move on to next feature ← Don't do this!

// ✅ Good: Refactor before moving on
@Test
void shouldDoSomething() {
    // Write test
}

// Make test pass
// Refactor for clean code ← Always do this!
// Ensure tests still pass
// Then move to next feature
```

### Don't Test Implementation Details

```java
// ❌ Bad: Testing internal implementation
@Test
void shouldCallPrivateMethodTwice() {
    // Using reflection to test private methods
    Method privateMethod = service.getClass()
        .getDeclaredMethod("privateMethod");
    privateMethod.setAccessible(true);
    // Testing internal behavior - fragile test
}

// ✅ Good: Testing public behavior
@Test
void shouldReturnCorrectResultFromPublicMethod() {
    String result = service.publicMethod();
    assertEquals(expectedValue, result);
    // Test the outcome, not how it's achieved
}
```

### Don't write Integration tests for edge and error cases. Only cover happy paths

## TDD Workflow Checklist

- [ ] Write a failing test first (RED)
- [ ] Run test to confirm it fails
- [ ] Write minimal code to pass test (GREEN)
- [ ] Run test to confirm it passes
- [ ] Refactor code while keeping tests green
- [ ] Run all tests to ensure nothing broke
- [ ] Commit changes
- [ ] Repeat for next feature
- [ ] As an exception, Integration tests are written after the feature(s) are complete to test the end to end flow

## Test Organization

### Co-locate Tests with Code

```java
// ✅ Recommended structure (Gradle)
src/
├── main/
│   └── java/
│       └── com/
│           └── example/
│               └── user/
│                   ├── UserService.java
│                   ├── UserRepository.java
│                   └── UserValidator.java
└── test/
    └── java/
        └── com/
            └── example/
                └── user/
                    ├── UserServiceTest.java
                    ├── UserRepositoryTest.java
                    └── UserValidatorTest.java
```

### Use Test Utilities

```java
// src/test/java/com/example/utils/TestHelpers.java
public class TestHelpers {
    
    public static User createMockUser() {
        return createMockUser(null);
    }
    
    public static User createMockUser(String email) {
        return new User(
            "1",
            email != null ? email : "test@example.com",
            "Test User",
            LocalDateTime.now()
        );
    }
    
    public static <T> T createMockRepository(Class<T> repositoryClass) {
        return mock(repositoryClass);
    }
}

// Usage in tests
class UserServiceTest {
    @Test
    void shouldCreateUser() {
        User mockUser = TestHelpers.createMockUser("custom@example.com");
        UserRepository mockRepo = TestHelpers.createMockRepository(UserRepository.class);
        // ... test implementation
    }
}
```

## Benefits of TDD

1. **Better Design**: Forces you to think about API before implementation
2. **Documentation**: Tests serve as living documentation
3. **Confidence**: Refactor fearlessly with comprehensive test coverage
4. **Fewer Bugs**: Catch issues early in development cycle
5. **Faster Development**: Less debugging time, faster iteration
6. **Maintainability**: Easier to modify code with safety net

## TDD for Different Scenarios

### Pure Functions

```java
// Test first
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class CurrencyFormatterTest {
    @Test
    void shouldFormatNumberAsUSDCurrency() {
        String result = CurrencyFormatter.format(new BigDecimal("1234.56"));
        assertEquals("$1,234.56", result);
    }
}

// Implement
import java.text.NumberFormat;
import java.util.Locale;

public class CurrencyFormatter {
    public static String format(BigDecimal amount) {
        NumberFormat formatter = NumberFormat.getCurrencyInstance(Locale.US);
        return formatter.format(amount);
    }
}
```

### Async Operations

```java
// Test first
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import java.util.concurrent.CompletableFuture;

class UserFetcherTest {
    @Test
    void shouldReturnUserDataWhenApiCallSucceeds() throws Exception {
        String userId = "123";
        User expectedUser = new User(userId, "John", "john@example.com");

        CompletableFuture<User> result = userFetcher.fetchUser(userId);

        assertEquals(expectedUser, result.get());
    }
}

// Implement
import java.util.concurrent.CompletableFuture;

public class UserFetcher {
    private final RestTemplate restTemplate;
    
    public UserFetcher(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
    
    public CompletableFuture<User> fetchUser(String userId) {
        return CompletableFuture.supplyAsync(() -> 
            restTemplate.getForObject("/api/users/" + userId, User.class)
        );
    }
}
```

### Error Handling

```java
// Test first
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class MathOperationsTest {
    @Test
    void shouldThrowErrorWhenDividingByZero() {
        ArithmeticException exception = assertThrows(
            ArithmeticException.class,
            () -> MathOperations.divide(10, 0)
        );
        assertEquals("Cannot divide by zero", exception.getMessage());
    }
}

// Implement
public class MathOperations {
    public static int divide(int a, int b) {
        if (b == 0) {
            throw new ArithmeticException("Cannot divide by zero");
        }
        return a / b;
    }
}
```

## Remember

> **"Write tests first, let tests drive design, keep tests green, refactor continuously."**

The goal is not just to have tests, but to use tests as a design tool that leads to better, cleaner, more maintainable code.
