#!/bin/bash

# Note: the script will occassionally detect processes whose binaries are blank
# (have no path).  These are processes that were present at the time of creating /tmp/pids.txt
# but have exited before their path could be determined.
# In most cases these are the jamf, mdworker, and ocsp processes but may also be processes
# related to the execution of this script itself

# We need to run as root so we can analyze all processes
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

while true; do

    #/bin/ps -eo comm > /tmp/pids.txt
    /bin/ps -eo pid > /tmp/pids.txt
    /bin/ps -eo pid,comm > /tmp/pids2.txt
    while IFS= read -r pid; do

        # skip the first line of ps -eo output
        if [[ "$pid" -eq "PID" ]]; then 
            continue
        fi

        fullp=`lsof -p $pid -Fn | awk 'NR==5{print}' | sed "s/n\//\//"`
        echo $fullp

        # List (or kill) any processes that are using variants of osascript 
        # or Mythic agents
 
        if /usr/bin/strings "$fullp" 2>/dev/null | grep -q -e 'osascript.m' -e 'MythicAgents' 2>/dev/null; then
 
            /bin/echo "Suspicious process:" $pid $fullp
            /bin/echo $proc >> /tmp/sus_process.txt

            # If you want the suspicious processes to be killed, uncomment this line:
            #/usr/bin/pkill -f $fullp
            #/bin/echo "Process killed ($pid: $fullp)"

    fi
    done < /tmp/pids.txt
done
