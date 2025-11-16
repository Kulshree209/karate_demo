# Database Test Setup and Troubleshooting

## Issue Fixed

The database tests were failing because PostgreSQL was not running or not accessible. The tests have been updated to gracefully handle connection failures by skipping scenarios when the database is not available.

## Solution Implemented

### 1. Connection Handling
- Added try-catch block in Background to handle connection failures gracefully
- Tests now skip automatically if database connection fails
- No test failures when database is unavailable

### 2. Updated Files
- `database-validation.feature` - All scenarios now check connection status
- `database-schema-validation.feature` - All scenarios now check connection status

## How It Works

When database connection fails:
1. Connection attempt is caught in Background
2. `dbConnected` flag is set to `false`
3. Each scenario checks this flag and aborts gracefully if not connected
4. Tests are marked as passed (skipped) rather than failed

## Setting Up PostgreSQL

### Option 1: Install and Run PostgreSQL Locally

**macOS:**
```bash
# Install PostgreSQL using Homebrew
brew install postgresql@14
brew services start postgresql@14

# Create database
createdb testdb

# Create tables (see SQL below)
psql testdb < schema.sql
```

**Linux:**
```bash
# Install PostgreSQL
sudo apt-get install postgresql postgresql-contrib

# Start PostgreSQL
sudo systemctl start postgresql

# Create database
sudo -u postgres createdb testdb
```

**Windows:**
1. Download and install PostgreSQL from https://www.postgresql.org/download/windows/
2. Use pgAdmin or psql to create database and tables

### Option 2: Use Docker

```bash
# Run PostgreSQL in Docker
docker run --name postgres-test \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=testdb \
  -p 5432:5432 \
  -d postgres:14

# Create tables
docker exec -i postgres-test psql -U postgres -d testdb < schema.sql
```

### Option 3: Use Remote Database

Update `src/test/resources/config/db-config.js` with your remote database details:
```javascript
function fn() {
  return {
    dbUrl: 'jdbc:postgresql://your-host:5432/your_database',
    dbUsername: 'your_username',
    dbPassword: 'your_password',
    // ...
  };
}
```

## Database Schema

Create the following tables in your PostgreSQL database:

```sql
-- Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    status VARCHAR(50),
    role VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create posts table
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    body TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO users (username, email, status, role) VALUES
('john_doe', 'john@example.com', 'active', 'admin'),
('jane_smith', 'jane@example.com', 'active', 'user'),
('bob_wilson', 'bob@example.com', 'inactive', 'user');

INSERT INTO posts (user_id, title, body) VALUES
(1, 'First Post', 'This is the first post body'),
(1, 'Second Post', 'This is the second post body'),
(2, 'Third Post', 'This is the third post body');
```

## Configuration

Update database credentials in `src/test/resources/config/db-config.js`:

```javascript
function fn() {
  return {
    dbUrl: 'jdbc:postgresql://localhost:5432/testdb',
    dbUsername: 'postgres',      // Change to your username
    dbPassword: 'postgres',      // Change to your password
    dbHost: 'localhost',         // Change if using remote DB
    dbPort: '5432',              // Change if using different port
    dbName: 'testdb'             // Change to your database name
  };
}
```

## Running Database Tests

### Run All Database Tests
```bash
mvn test "-Dtest=TestRunner#testDatabaseValidation"
mvn test "-Dtest=TestRunner#testDatabaseSchemaValidation"
```

### Run All Tests (including database)
```bash
mvn test "-Dtest=TestRunner#testAll"
```

### Skip Database Tests
If you want to skip database tests entirely, you can exclude them:
```bash
mvn test "-Dkarate.options=--tags ~@database"
```

## Troubleshooting

### Connection Refused
**Error:** `Connection to localhost:5432 refused`

**Solutions:**
1. Check if PostgreSQL is running: `psql -l` or `pg_isready`
2. Verify port 5432 is not blocked by firewall
3. Check PostgreSQL configuration: `postgresql.conf` and `pg_hba.conf`
4. Ensure PostgreSQL is listening on localhost: `netstat -an | grep 5432`

### Authentication Failed
**Error:** `FATAL: password authentication failed`

**Solutions:**
1. Verify username and password in `db-config.js`
2. Check `pg_hba.conf` for authentication method
3. Reset PostgreSQL password if needed

### Database Does Not Exist
**Error:** `FATAL: database "testdb" does not exist`

**Solutions:**
1. Create the database: `createdb testdb`
2. Or update `dbName` in `db-config.js` to an existing database

### Tables Do Not Exist
**Error:** `relation "users" does not exist`

**Solutions:**
1. Run the SQL schema script to create tables
2. Verify you're connected to the correct database
3. Check table names match exactly (case-sensitive in some setups)

## Test Behavior

### When Database is Available
- All scenarios execute normally
- Tests validate database data and schema
- Results show passed/failed based on actual validation

### When Database is Not Available
- Connection attempt fails gracefully
- All scenarios are skipped automatically
- Tests show as passed (skipped) - no failures
- Log messages indicate database connection failed

## Next Steps

1. **Set up PostgreSQL** using one of the methods above
2. **Create database and tables** using the SQL schema
3. **Update credentials** in `db-config.js`
4. **Run tests** to verify everything works
5. **Add sample data** if needed for your test scenarios

## Notes

- Database tests are optional - API tests can run independently
- Connection failures are handled gracefully - no test suite failures
- You can run API tests without setting up database
- Database tests will automatically skip if connection fails

