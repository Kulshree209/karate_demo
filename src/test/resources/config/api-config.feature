@config
Feature: API Configuration

  Background:
    * def apiConfig = read('classpath:config/api-config.js')
    * def baseUri = apiConfig.baseUri
    * def apiToken = apiConfig.apiToken
    * def apiKey = apiConfig.apiKey
    * def username = apiConfig.username
    * def password = apiConfig.password
    * def authHeader = 'Bearer ' + apiToken
    * def timeout = apiConfig.timeout

