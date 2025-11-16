// Common utility functions for Karate tests

/**
 * Generate a random string
 */
function randomString(length) {
  var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  var result = '';
  for (var i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

/**
 * Generate a random email
 */
function randomEmail() {
  return 'test_' + randomString(8) + '@example.com';
}

/**
 * Generate a random integer between min and max
 */
function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

/**
 * Get current timestamp
 */
function getCurrentTimestamp() {
  return new Date().getTime();
}

/**
 * Get current date in ISO format
 */
function getCurrentDate() {
  return new Date().toISOString().split('T')[0];
}

