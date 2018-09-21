# Bank account

An small application to make transfers between accounts and get the balance of
an account.

## Tecnologies

* Ruby 2.3.0
* Rails 5.2.1

## Setup dev enviroment

    bin/setup

## Running tests

    rspec

## Endpoints

### Transfer money

* To transfer money between accounts use:

    POST /api/transfers

    Parameters:
    source_account_id, destination_account_id and amount

    ```
    curl -X POST http://localhost:4000/api/transfers \
            -H 'Cache-Control: no-cache' \
            -H 'Content-Type: application/json' \
            -d '{"source_account_id" : 1, "destination_account_id" : 2, "amount" : 500.01 }'
    ```

### Get Account balance

* To recover the account balance use:

    GET /api/account_balance/:account_id

    Parameters:
    account_id

    ```
        curl -X GET http://localhost:4000/api/account_balance/1 \
                -H 'Cache-Control: no-cache' \
    ```
