## sh


### Backgrounding

Often you will want to be able to run processes in the background during the contest.
There are a few ways to do this:

* job control - this is the legacy job control system.
* tmux/screen - if they are installed, these are more full featured tools

```sh
#!/bin/sh
# run an update with yum in the background writing the log to
# '/var/log/yum_updates' that will continue running even if the user logs out
nohup yum update -y >>/var/log/yum_updates 2>&1 &

# see the running list of jobs
jobs -l

# send a job to the background
bg

# send a job to the foreground
fg

# disown a process after you start it
disown
```


### Scripting

```sh
#!/bin/sh
# for loop that outputs 1 2 3 4 5 6 7 8 9 10 a b c
for i in {1..10} a b c
do
	echo $i
done

# conditional testing for an empty string
foo="bar"
if [ -z "$foo" ]; then
	echo $foo
fi

# conditional testing equal stings
if [ "$foo" == "bar" ]; then
	echo $foo
fi

# conditional testing numeric values
if [ 1 -eq 2 ]; then
	echo $foo
fi

# example function
foobar(){
	echo $1
}
foobar "this echos this statement"
```
