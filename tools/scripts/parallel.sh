#!/bin/bash
# A script that allows faking 1 to many ssh

file="$1"
command="${*:2}"
while read line; do
	${command/\{\}/"$line"} &
done <"$file"

