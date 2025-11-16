@config
Feature: Database Configuration

  Background:
    * def dbConfig = read('classpath:config/db-config.js')
    * def dbUrl = dbConfig.dbUrl
    * def dbUsername = dbConfig.dbUsername
    * def dbPassword = dbConfig.dbPassword
    * def dbHost = dbConfig.dbHost
    * def dbPort = dbConfig.dbPort
    * def dbName = dbConfig.dbName

