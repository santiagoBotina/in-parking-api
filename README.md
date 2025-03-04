# IN PARKING API

InParking API is a RESTful API that provides a way to manage parking lots and parking spaces.
It is built using Ruby on Rails, AWS and PostgreSQL.

How to run it locally:

Install postgreSQL on your machine or run a docker container with the following command:

`docker run --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres`

Then, follow these steps:

1. Clone the repository
2. Install the required gems by running `bundle install`
3. Create the database by running `rails db:create`
4. Run the migrations by running `rails db:migrate`
5. Create a .env file and replace the variables with your AWS credentials and local env.
6. Run the docker compose file by running `docker-compose up`
7. Run the server by running `rails s`
8. The server will be running on `http://localhost:3000`

We can use Postman or any other API client to test the API.
