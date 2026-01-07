-- Tasbal Database Initialization Script
-- This script runs automatically when PostgreSQL container starts for the first time

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Set timezone to UTC
SET timezone = 'UTC';

-- Note: Application tables will be created by Flyway migrations