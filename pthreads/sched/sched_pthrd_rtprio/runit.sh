#!/bin/bash
# runit.sh
# Run the demo sched_pthrd MT app (that spwans off SCHED_FIFO threads)

[ ! -f sched_pthrd_rtprio_dbg ] && {
  echo "$0: build it first pl..."
  exit 1
}
#--- 'Old' way: via sudo
# Allow it to only execute on core #1
#sudo taskset -c 01 ./sched_pthrd_rtprio_dbg 20

#--- 'New' way: via capabilities!
# There's a better approach to using sudo; we use the powerful POSIX
# Capabilities model instead! This way, the process (and threads) get _only_
# the capabilities they require and nothing more. Reduces the attack surface
echo "[+] sudo setcap CAP_SYS_NICE+eip ./sched_pthrd_rtprio_dbg"
sudo setcap CAP_SYS_NICE+eip ./sched_pthrd_rtprio_dbg
echo "[+] getcap ./sched_pthrd_rtprio_dbg"
getcap ./sched_pthrd_rtprio_dbg

# Still have to run it on exactly one core though!!
echo "[+] taskset -c 01 ./sched_pthrd_rtprio_dbg 20"
taskset -c 01 ./sched_pthrd_rtprio_dbg 20
