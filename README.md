# SimpleAV
A simple script that continuously scans MacOS and alerts on processes that contain certain strings in their "strings" output - useful for if an attacker copies /usr/bin/osascript to /tmp/notosa and tries to execute that, for instance.

Run the scanner by simply doing a:
nohup ./simpleAV.sh &

Note: Don't forget to run it as root if you want to analyze all system processes!

Currently, SimpleAV will detect:
- Mythic agents
- osascripts

If you or your threat intel team is keen on searching for other things, simply add the strings you're looking for with a grep -e inside the script.

To do #1: faster detections on osascript
In the case of an attacker prompting users for passwords via JXA, such a prompt will typically only be up for ~20 seconds.  I need to find a way to improve the speed at which this script detects those.  Maybe spend more time iterating through the highest-numbered processes first?

To do #2: what if your org typically runs osascript, and this script gives a bunch of false positives?
In that case, I'll need to scan the contents of the *arguments* to osascript, to suss out malicious scripts.
