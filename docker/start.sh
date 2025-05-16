#!/bin/bash

php artisan config:clear
php artisan cache:clear

php artisan migrate --force --no-interaction

# Start PHP-FPM
php-fpm &

# Start Nginx
nginx -g "daemon off;"
