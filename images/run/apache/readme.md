# Introduction

This provides the apache+php5.6 module for clam-p. Nothing too special about it, it includes some stuff for running WordPress.

**This container is currently broke as a billboard**

# Building from source

``` bash
docker build -t clamp/run-apache images/apache
```

# Running from source

``` yml
php-apache:
  build: images/apache
  volumes_from:
    - wordpress # The clamp/run-wordpress image
  ports:
    - "80:80"
  links:
    - "db:db" # The clamp/run-mysql image
    - "db_slave:db_slave" # The clamp/run-mysql image
  environment:
    DB_NAME: "wordpress"
    DB_USER: "admin"
    DB_PASSWORD: "password"
    DB_HOST: "1234"
    WP_ENV: "development"
    WP_HOME: "http://192.168.99.100"
    WP_SITE_URL: "http://192.168.99.100"
    AUTH_KEY: ""
    SECURE_AUTH_KEY: ""
    LOGGED_IN_KEY: ""
    NONCE_KEY: ""
    AUTH_SALT: ""
    SECURE_AUTH_SALT: ""
    LOGGED_IN_SALT: ""
    NONCE_SALT: ""
```