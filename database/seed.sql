
INSERT INTO accounts (account_type, balance)
VALUES ('Checking', 5240.75);

INSERT INTO transactions (account_id, description, amount)
SELECT account_id, 'Grocery Store', -85.20
FROM accounts
WHERE account_type = 'Checking';

INSERT INTO transactions (account_id, description, amount)
SELECT account_id, 'Payroll Deposit', 2500.00
FROM accounts
WHERE account_type = 'Checking';

INSERT INTO transactions (account_id, description, amount)
SELECT account_id, 'Electric Bill', -120.50
FROM accounts
WHERE account_type = 'Checking';

