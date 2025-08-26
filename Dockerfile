# ===== Base PHP-FPM =====
FROM php:8.2-fpm-alpine AS base

RUN apk add --no-cache \
    git curl zip unzip libpng-dev libjpeg-turbo-dev libwebp-dev libzip-dev oniguruma-dev icu-dev \
    bash shadow \
 && docker-php-ext-configure gd --with-jpeg --with-webp \
 && docker-php-ext-install gd mbstring pdo pdo_mysql intl zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . /var/www/html

RUN chown -R www-data:www-data /var/www/html \
 && chmod -R 775 storage bootstrap/cache

FROM base AS app
CMD ["php-fpm"]
