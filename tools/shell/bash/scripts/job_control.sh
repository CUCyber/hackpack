#Run an update with yum in the background writing the log to
#/var/log/yum_updates that will continue running even if the user log out
nohup yum update -y >>/var/log/yum_updates 2>&1 &

#see the running list of jobs
jobs -l

#send a job to the background
bg

#send a job to the foreground
fg

#disown a process after you start it
disown
