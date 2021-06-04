FROM php:7.4.20-fpm

ENV PHP_CPPFLAGS="$PHP_CPPFLAGS -std=c++11"

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        libc-client-dev \
        libkrb5-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libonig-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libzip-dev \
        unzip \
        zlib1g-dev \
    && apt-get clean

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install \
        bcmath \
        gd \
        imap \
        intl \
        json \
        mbstring \
        opcache \
        pdo_pgsql \
        soap \
        sockets \
        xml \
        zip \
    && pecl install apcu && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini \
    && pecl install redis && echo extension=redis.so > /usr/local/etc/php/conf.d/redis.ini

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /bin/composer

VOLUME /var/www/html
