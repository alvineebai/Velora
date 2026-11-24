
from fastapi import FastAPI, HTTPException
from database import get_connection

app = FastAPI(title="Velora API")


# Check whether the FastAPI application is running.
@app.get("/health")
def health():
    return {
        "status": "healthy",
        "service": "velora-api"
    }


# Retrieve account information from PostgreSQL.
@app.get("/account")
def get_account():
    try:
        with get_connection() as conn:
            with conn.cursor() as cursor:

                # Retrieve the first account.
                cursor.execute("""
                    SELECT account_id, account_type, balance
                    FROM accounts
                    ORDER BY account_id
                    LIMIT 1;
                """)

                account = cursor.fetchone()

                if account is None:
                    raise HTTPException(
                        status_code=404,
                        detail="Account not found"
                    )

                # Retrieve transactions for this account.
                cursor.execute("""
                    SELECT description, amount
                    FROM transactions
                    WHERE account_id = %s
                    ORDER BY transaction_id;
                """, (account[0],))

                transactions = cursor.fetchall()

        return {
            "account_type": account[1],
            "balance": float(account[2]),
            "transactions": [
                {
                    "description": transaction[0],
                    "amount": float(transaction[1])
                }
                for transaction in transactions
            ]
        }

    except HTTPException:
        raise

    except Exception:
        raise HTTPException(
            status_code=503,
            detail="Database unavailable"
        )


# Check whether PostgreSQL is accessible.
@app.get("/db-health")
def database_health():
    try:
        with get_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT 1;")
                cursor.fetchone()

        return {
            "status": "connected"
        }

    except Exception:
        raise HTTPException(
            status_code=503,
            detail="Database unavailable"
        )
