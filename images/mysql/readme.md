# Introduction

Mysql container, no modifications at this point

# Building from source

``` bash
docker build -t clamp/run-mysql images/mysql
```

# Running from source

``` yml
db:
  build: images/mysql
  volumes_from:
    - db-data # A data volume
  environment:
    ON_CREATE_DB: "wordpress"
    REPLICATION_MASTER: "true"
    REPLICATION_PASS: "replica"
    MYSQL_PASS: "password"
  ports:
    - "3306:3306"
```