## How to setup a working environment

This project is a simple Laravel 9 application

### Docker

For the docker environment, we prepared a special `.env` file example: `.env.example`.
In addition to that, we included a basic Docker Compose config.
So, if you are already a docker user, you simply need to execute the following commands:

```sh
# Copy the example .env file
cp .env.docker.example .env

# Build, (re)create and start containers for a service.
docker-compose up -d

# Install composer dependencies
docker-compose exec app composer install

# Run all migrations and seed the DB
docker-compose exec app php artisan migrate:fresh --seed

# Generate application key
docker-compose exec app php artisan key:generate

# Install front end dependencies
docker-compose exec front yarn install

# Build front end assets (CSS, JS)
docker-compose exec front yarn dev
```

If everything worked well, a project should be accessible by [http://localhost:8080](http://localhost:8080)..
