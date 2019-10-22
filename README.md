# nginx-php7-alpine
[![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)

A simple Docker container running PHP

## Introduction
A Docker container running nginx and php-fpm using [alpine](https://hub.docker.com/_/alpine) as base layer.

## Usage
Use this as a base image e.g. `FROM: stormheg/nginx-php7-alpine` in your own Dockerfile.

You can easily tweak a few nginx and php configuration options by setting environment variables. See [Variables](#variables)



## The PRE_START task
The pre_start.sh script located in /etc/pre_start.sh is run by supervisor before php-fpm and nginx are started.

You may append any commands you want executed when the container starts

## Variables
Currently teakable variables are: \
`PHP_MEMORY_LIMIT` default: 128mb \
`PHP_UPLOAD_MAX_FILESIZE` default: 20mb \
`PHP_POST_MAX_SIZE` default: 20mb \
`PHP_ALLOW_URL_FOPEN` default: Off
