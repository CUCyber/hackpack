#!/bin/sh
openssl req -x509 -newkey rsa:2048 -nodes -sha256 -days 365 -keyout example.pem -out example.crt -subj '/O=Example, Inc./CN=example.com'
