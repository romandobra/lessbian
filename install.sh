#!/usr/bin/env bash

source functions.sh

# [ -z "$( ls -A $LESSBIAN_MNT )" ]\
#   || echo_script "Target is not empty LESSBIAN_MNT=$LESSBIAN_MNT" 3

( chroot --help ) > /dev/null




exit
