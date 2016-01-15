# Introduction

This is a memcached image that has some really awesome settings...

Available env vars:
- MAX_CONN: Max number of connections
- MAX_REQ: Max number of requests before sharing (-R option)
- SIZE: Size of the cache
- FACTOR: The factor to grow the slabs by
- KEY_SIZE: The size in bytes of the key:value store
- THREADS: Number of threads to run
- DELIMETER: Delimeter for key:value
- PROTOCOL: "auto", "binary" or "ascii"
- SLAB: size of slab page

# Building

``` bash
docker build -t clamp/run-memcached images/memcached
```