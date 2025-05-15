#!/bin/bash

php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start PHP-FPM
php-fpm &

# Start Nginx
nginx -g "daemon off;"
