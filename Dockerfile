FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    nginx \
    git \
    curl \
    unzip \
    zip \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN rm -f .env

RUN composer install --no-dev --optimize-autoloader

RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

COPY docker/nginx.conf /etc/nginx/nginx.conf

COPY docker/default.conf /etc/nginx/conf.d/default.conf

RUN rm /etc/nginx/sites-enabled/default

EXPOSE 80

COPY docker/start.sh /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
