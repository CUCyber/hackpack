## Parallel

The following script takes in a file then command parameter in and for every server in the file, it runs the command on that server.

```sh
#!/bin/sh
file="$1"
cmd="${*:2}"
while read server; do
  (ssh $server $cmd) &
done <"$file"
wait
```
