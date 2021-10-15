#!/bin/bash

# We need to run as root so we can analyze all processes
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

while true; do

    #/bin/ps -eo comm > /tmp/pids.txt
    /bin/ps -eo pid > /tmp/pids.txt
    while IFS= read -r pid; do
        if [[ "$pid" -eq "PID" ]]; then
            continue
        fi

        fullp=`lsof -p $pid -Fn | awk 'NR==5{print}' | sed "s/n\//\//"`
#        echo $fullp

        # List (or kill) any processes that are using variants of osascript
        # or Mythic agents

        if /usr/bin/strings "$fullp" 2>/dev/null | grep -q -e 'osascript.m' -e 'MythicAgents' 2>/dev/null; then

            /bin/echo "Suspicious process:" $pid $fullp
            /bin/echo $proc >> /tmp/found_mythic.txt
            /bin/echo "Normally would kill $pid here!"

            # If you want the suspicious processes to be killed, uncomment this line:
            #/usr/bin/pkill -f $fullp

    fi
    done < /tmp/pids.txt
done
