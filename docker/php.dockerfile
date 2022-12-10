FROM php:8.1-fpm

# Arguments defined in docker-compose.yml
ARG USER_ID
ARG GROUP_ID

# Install system dependencies
RUN apt-get update && apt-get install -y \
    zip \
    unzip

# Install ext-redis
# check for versions here https://github.com/phpredis/phpredis/releases
ARG PHP_REDIS_VERSION=5.3.7
RUN apt-get install -y libonig-dev
RUN curl -fsSL https://github.com/phpredis/phpredis/archive/${PHP_REDIS_VERSION}.tar.gz --output /tmp/redis.tar.gz \
        && tar xfz /tmp/redis.tar.gz --directory /tmp \
        && rm -r /tmp/redis.tar.gz \
        && mkdir -p /usr/src/php/ext \
        && mv /tmp/phpredis-* /usr/src/php/ext/redis \
        && docker-php-ext-install redis

# Install node
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring pcntl bcmath

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $GROUP_ID -d /home/$USER_ID $USER_ID
RUN mkdir -p /home/$USER_ID/.composer && \
    chown -R $USER_ID:$USER_ID /home/$USER_ID

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory (default is /var/www/html)
WORKDIR /var/www

USER $USER_ID
