// API Configuration - Update these values with your actual API credentials
function fn() {
  return {
    baseUri: 'https://jsonplaceholder.typicode.com',
    apiToken: 'your-api-token-here',
    apiKey: 'your-api-key-here',
    username: 'your-username',
    password: 'your-password',
    timeout: 30000,
    // Mastercard API Gateway OAuth 1.0 Configuration
    mastercardBaseUrl: 'https://stage.api.gateway.mastercard.com',
    mastercardConsumerKey: 'your-consumer-key-here',
    mastercardPrivateKey: 'your-private-key-here' // PKCS#8 format private key (base64 encoded or PEM)
  };
}

