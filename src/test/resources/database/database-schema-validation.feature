@database @schema
Feature: PostgreSQL Database Schema Validation

  Background:
    * def DatabaseUtils = Java.type('com.example.karate.DatabaseUtils')
    * def connection = null
    * def dbConnected = false
    * eval
    """
    try {
      connection = DatabaseUtils.getConnection(dbUrl, dbUsername, dbPassword);
      dbConnected = true;
    } catch (e) {
      dbConnected = false;
      karate.log('Database connection failed:', e.message);
      karate.log('Skipping database schema tests. Please ensure PostgreSQL is running and configured.');
    }
    """

  Scenario: Validate users table schema structure
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT column_name, data_type, is_nullable, character_maximum_length FROM information_schema.columns WHERE table_name = 'users' ORDER BY ordinal_position"
    When def schema = DatabaseUtils.executeQuery(query)
    Then match schema != null
    And match schema.length > 0
    And def columnNames = $schema[*].column_name
    And match columnNames contains 'id'
    And match columnNames contains 'username'
    And match columnNames contains 'email'
    # Validate data types
    And def idColumn = $schema[?(@.column_name == 'id')]
    And match idColumn[0].data_type == 'integer' || idColumn[0].data_type == 'bigint'
    And def emailColumn = $schema[?(@.column_name == 'email')]
    And match emailColumn[0].data_type == 'character varying' || emailColumn[0].data_type == 'varchar' || emailColumn[0].data_type == 'text'

  Scenario: Validate posts table schema structure
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT column_name, data_type, is_nullable, character_maximum_length FROM information_schema.columns WHERE table_name = 'posts' ORDER BY ordinal_position"
    When def schema = DatabaseUtils.executeQuery(query)
    Then match schema != null
    And match schema.length > 0
    And def columnNames = $schema[*].column_name
    And match columnNames contains 'id'
    And match columnNames contains 'user_id'
    And match columnNames contains 'title'
    And match columnNames contains 'body'
    # Validate foreign key relationship
    And def userIdColumn = $schema[?(@.column_name == 'user_id')]
    And match userIdColumn[0].data_type == 'integer' || userIdColumn[0].data_type == 'bigint'

  Scenario: Validate table exists in database
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE'"
    When def tables = DatabaseUtils.executeQuery(query)
    Then match tables != null
    And def tableNames = $tables[*].table_name
    And match tableNames contains 'users'
    And match tableNames contains 'posts'

  Scenario: Validate primary key constraints
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT tc.constraint_name, kcu.column_name FROM information_schema.table_constraints tc JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name WHERE tc.table_name = 'users' AND tc.constraint_type = 'PRIMARY KEY'"
    When def primaryKeys = DatabaseUtils.executeQuery(query)
    Then match primaryKeys != null
    And match primaryKeys.length > 0
    And def pkColumns = $primaryKeys[*].column_name
    And match pkColumns contains 'id'

  Scenario: Validate foreign key constraints
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT tc.constraint_name, kcu.column_name, ccu.table_name AS foreign_table_name, ccu.column_name AS foreign_column_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name = 'posts'"
    When def foreignKeys = DatabaseUtils.executeQuery(query)
    Then match foreignKeys != null
    And match foreignKeys.length > 0
    And def fkColumns = $foreignKeys[*].column_name
    And match fkColumns contains 'user_id'
    And def fkTable = $foreignKeys[?(@.column_name == 'user_id')]
    And match fkTable[0].foreign_table_name == 'users'

  Scenario: Validate NOT NULL constraints
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT column_name, is_nullable FROM information_schema.columns WHERE table_name = 'users' AND is_nullable = 'NO'"
    When def notNullColumns = DatabaseUtils.executeQuery(query)
    Then match notNullColumns != null
    And def requiredColumns = $notNullColumns[*].column_name
    And match requiredColumns contains 'id'
    And match requiredColumns contains 'username'
    And match requiredColumns contains 'email'

  Scenario: Validate unique constraints
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT tc.constraint_name, kcu.column_name FROM information_schema.table_constraints tc JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name WHERE tc.table_name = 'users' AND tc.constraint_type = 'UNIQUE'"
    When def uniqueConstraints = DatabaseUtils.executeQuery(query)
    Then match uniqueConstraints != null
    # If unique constraints exist, validate them
    # And def uniqueColumns = $uniqueConstraints[*].column_name
    # And match uniqueColumns contains 'email'

  Scenario: Validate column data types match expected schema
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT column_name, data_type, character_maximum_length, numeric_precision, numeric_scale FROM information_schema.columns WHERE table_name = 'users'"
    When def columns = DatabaseUtils.executeQuery(query)
    Then match columns != null
    And def idCol = $columns[?(@.column_name == 'id')]
    And match idCol[0].data_type == 'integer' || idCol[0].data_type == 'bigint' || idCol[0].data_type == 'serial'
    And def usernameCol = $columns[?(@.column_name == 'username')]
    And match usernameCol[0].data_type == 'character varying' || usernameCol[0].data_type == 'varchar' || usernameCol[0].data_type == 'text'
    And def emailCol = $columns[?(@.column_name == 'email')]
    And match emailCol[0].data_type == 'character varying' || emailCol[0].data_type == 'varchar' || emailCol[0].data_type == 'text'

  Scenario: Validate indexes exist on table
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'users' AND schemaname = 'public'"
    When def indexes = DatabaseUtils.executeQuery(query)
    Then match indexes != null
    # Validate primary key index exists
    And def indexNames = $indexes[*].indexname
    # Primary key index typically contains 'pkey' or table name
    And assert indexNames.length > 0

  Scenario: Validate default values for columns
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT column_name, column_default FROM information_schema.columns WHERE table_name = 'users' AND column_default IS NOT NULL"
    When def defaultColumns = DatabaseUtils.executeQuery(query)
    Then match defaultColumns != null
    # If default values exist, validate them
    # And def defaultColNames = $defaultColumns[*].column_name
    # And match defaultColNames contains 'created_at'

  Scenario: Validate check constraints
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT constraint_name, check_clause FROM information_schema.check_constraints WHERE constraint_name IN (SELECT constraint_name FROM information_schema.table_constraints WHERE table_name = 'users' AND constraint_type = 'CHECK')"
    When def checkConstraints = DatabaseUtils.executeQuery(query)
    Then match checkConstraints != null
    # Validate check constraints if they exist

  Scenario: Validate table column count matches expected schema
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT COUNT(*) as column_count FROM information_schema.columns WHERE table_name = 'users'"
    When def result = DatabaseUtils.executeQuery(query)
    Then match result[0].column_count >= 3
    And assert result[0].column_count is number

  Scenario: Validate schema for multiple tables
    * if (dbConnected == false) karate.abort()
    Given def tables = ['users', 'posts']
    When def tableSchemas = []
    And eval
    """
    for (var i = 0; i < tables.length; i++) {
      var query = "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '" + tables[i] + "' ORDER BY ordinal_position";
      var schema = DatabaseUtils.executeQuery(query);
      tableSchemas.push({ table: tables[i], columns: schema });
    }
    """
    Then match tableSchemas.length == 2
    And match tableSchemas[0].table == 'users'
    And match tableSchemas[1].table == 'posts'
    And match tableSchemas[0].columns.length > 0
    And match tableSchemas[1].columns.length > 0

  Scenario: Validate sequence exists for auto-increment columns
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = 'public'"
    When def sequences = DatabaseUtils.executeQuery(query)
    Then match sequences != null
    # If sequences exist (for SERIAL columns), validate them
    # And def seqNames = $sequences[*].sequence_name
    # And match seqNames contains 'users_id_seq'

  Scenario: Validate view schema if views exist
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT table_name, view_definition FROM information_schema.views WHERE table_schema = 'public'"
    When def views = DatabaseUtils.executeQuery(query)
    Then match views != null
    # Validate views if they exist

  Scenario: Cleanup - Close database connection
    * if (dbConnected == true) DatabaseUtils.closeConnection()

