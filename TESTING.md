# Testing Guide

## Server Tests (Node.js/Express)

### Setup

1. Install test dependencies:

```bash
cd Server
npm install
```

2. Set up test environment:

```bash
# Create test database
export MONGO_URI="mongodb://127.0.0.1:27017/sampletube_test"
```

### Running Tests

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage
```

### Test Files

- `tests/auth.test.js` - Authentication API tests (register/login)
- `tests/videos.test.js` - Video API tests (protected endpoints)
- `tests/utils.test.js` - Utility function tests (password hashing, JWT)

### Test Coverage

- API endpoints (auth, videos)
- Input validation
- Error handling
- Database operations
- Utility functions

## iOS App Tests (Swift/XCTest)

### Setup

1. Open `SampleTube.xcworkspace` in Xcode
2. Select the `SampleTubeTests` target
3. Add test files to the target

### Running Tests

- **In Xcode**: Cmd+U or Product → Test
- **Command Line**: `xcodebuild test -workspace SampleTube.xcworkspace -scheme SampleTube`

### Test Files

- `APIClientTests.swift` - Network layer tests
- `TokenStoreTests.swift` - Keychain storage tests
- `ThumbnailGeneratorTests.swift` - Video thumbnail generation tests
- `ModelsTests.swift` - Data model tests

### Test Coverage

- Network requests and responses
- Token storage and retrieval
- Video thumbnail generation
- Data model serialization
- Error handling

## Test Data

- Server tests use a separate test database
- iOS tests can use mock data or test video files
- All tests clean up after themselves

## Continuous Integration

Both test suites can be integrated into CI/CD pipelines:

- Server: Jest with coverage reporting
- iOS: Xcode build system with XCTest
