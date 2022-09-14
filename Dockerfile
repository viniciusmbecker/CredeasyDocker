FROM php:8.1.9-fpm
 
# Copy composer.lock and composer.json into the working directory
COPY composer.lock composer.json /var/www/html/
 
# Set working directory
WORKDIR /var/www/html/
 
# Install dependencies for the operating system software
RUN apt-get update && apt-get install -y \
    build-essential \
    zip \
    libzip-dev \
    unzip \
    libonig-dev \
    curl
 
# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
 
# Install extensions for php
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
 
# Install composer (php package manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
 
# Copy existing application directory contents to the working directory
  COPY . /var/www/html
 
# Assign permissions of the working directory to the www-data user
RUN chown -R www-data:www-data \
        /var/www/html/storage \
        /var/www/html/bootstrap/cache
 
# Expose port 9000 and start php-fpm server (for FastCGI Process Manager)
EXPOSE 9000
CMD ["php-fpm"]