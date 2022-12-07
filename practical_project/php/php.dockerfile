FROM php:7.2-apache

#Extensions to install
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN docker-php-ext-enable mysqli