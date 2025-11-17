// Karate configuration file
function fn() {
  var env = karate.env || 'dev'; // default to 'dev' environment
  
  // Load configuration from config files
  var apiConfig = karate.read('classpath:config/api-config.js')();
  var dbConfig = karate.read('classpath:config/db-config.js')();
  
  var config = {
    env: env,
    // API Configuration from config file
    baseUrl: apiConfig.baseUri,
    apiToken: apiConfig.apiToken,
    apiKey: apiConfig.apiKey,
    username: apiConfig.username,
    password: apiConfig.password,
    authHeader: 'Bearer ' + apiConfig.apiToken,
    timeout: apiConfig.timeout,
    // Mastercard API Gateway OAuth 1.0 Configuration
    mastercardBaseUrl: apiConfig.mastercardBaseUrl,
    mastercardConsumerKey: apiConfig.mastercardConsumerKey,
    mastercardPrivateKey: apiConfig.mastercardPrivateKey,
    // Database Configuration from config file
    dbUrl: dbConfig.dbUrl,
    dbUsername: dbConfig.dbUsername,
    dbPassword: dbConfig.dbPassword,
    dbHost: dbConfig.dbHost,
    dbPort: dbConfig.dbPort,
    dbName: dbConfig.dbName
  };
  
  // Environment-specific overrides
  if (env === 'dev') {
    // Use default values from config files
  } else if (env === 'staging') {
    config.baseUrl = 'https://staging-api.example.com';
    config.dbUrl = 'jdbc:postgresql://staging-db.example.com:5432/' + config.dbName;
  } else if (env === 'prod') {
    config.baseUrl = 'https://api.example.com';
    config.dbUrl = 'jdbc:postgresql://prod-db.example.com:5432/' + config.dbName;
  }
  
  return config;
}

