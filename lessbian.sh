#!/bin/bash

. functions.sh

if [ -z "$1" ]; then echo "No parameters are given! Try '$0 rctpdk'" && exit 1; fi
if [ -z "${1##*r*}" ]; then lreset; fi # rESET
if [ -z "${1##*c*}" ]; then lchroot; fi # cHROOT
if [ -z "${1##*t*}" ]; then ltoram; fi # tORAM
if [ -z "${1##*a*}" ]; then lautostart; fi # aUTOSTART
if [ -z "${1##*p*}" ]; then lpack; fi # pACK
if [ -z "${1##*d*}" ]; then rm -rf edit; rm -rf iso; fi # dELETE
if [ -z "${1##*k*}" ]; then kvm -m 4096 -vga virtio -boot d -cdrom lessbian.iso& fi # kVM

exit 0
