#!/bin/bash

# -----------------------------------------------------------------------------
# JIBRI-EPHEMERAL-START.SH
# -----------------------------------------------------------------------------
#
# Create and run the ephemeral Jibri containers. The number of containers
# depends on the CORES count (one Jibri instance per 2 cores) but it can not be
# more than LIMIT. The cores count is token into account if it's greater than
# RESERVED.
#
# For example, if there are 8 cores and 2 of them are reserved, the remaining 6
# cores are used for the Jibri instances. So there will be 3 active Jibri
# instances ( 6/2 = 3 )
#
# -----------------------------------------------------------------------------

# The maximum number of the Jibri instances. This is related with the ALSA
# loopback count. See /etc/modprobe.d/alsa-loop.conf on the host.
LIMIT=16

# The reserved cores count. The number of the cores which is not token into
# account to calculate the number of Jibri instances.
RESERVED=2

# The total cores
CORES=$(nproc --all)

# The available cores count
(( N = LIMIT * 2 ))
(( M = CORES - RESERVED ))
[[ $N -gt $M ]] && N=$M

for c in $(seq 2 2 $N); do
    (( ID = c / 2 ))

    lxc-copy -n eb-jibri-template -N eb-jibri-$ID -e
done
