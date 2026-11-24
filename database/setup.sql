
-- Create the application login role.
-- Its password will be configured separately.

CREATE ROLE velora_app
WITH LOGIN;

-- Allow the application to connect to Velora.
GRANT CONNECT ON DATABASE velora TO velora_app;

-- Allow access to the public schema.
GRANT USAGE ON SCHEMA public TO velora_app;


-- Grant read-only access to banking tables.
GRANT SELECT ON TABLE accounts TO velora_app;
GRANT SELECT ON TABLE transactions TO velora_app;
