# Builds the file_handler
FROM clamp/composer:latest

ENTRYPOINT composer

COPY . /clam-lib/file_handler

WORKDIR /clam-lib/file_handler

RUN composer install