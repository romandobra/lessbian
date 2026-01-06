#!/usr/bin/env bash

source functions.sh

# [ -z "$( ls -A $LESSBIAN_MNT )" ]\
#   || echo_script "Target is not empty LESSBIAN_MNT=$LESSBIAN_MNT" 3

( debootstrap --help; chroot --help ) > /dev/null


report_step(){
  echo_script "$1 $2"
  echo "export LESSBIAN_BASE_${1}_STEP=$2"\
    >> $LESSBIAN_MNT/etc/lessbian.env\
    || true; }


cleanup_base(){
  echo_script "Clean up target"

  if mount | grep -q "$LESSBIAN_MNT"; then
    exit_script "Unmount everything in $LESSBIAN_MNT first."; fi

  rm -rf $LESSBIAN_MNT/*; }


pack_base(){
  echo_script "Pack base $1"
  local DIR
  DIR=$(pwd)
  cd $LESSBIAN_MNT
  tar -cf $DIR/_base/$LESSBIAN_DR/$1.tar.gz .
  cd $DIR; }


unpack_base(){
  cleanup_base
  echo_script "Unack base $1"
  tar -xf _base/$LESSBIAN_DR/$1.tar.gz -C $LESSBIAN_MNT; }


last_packed(){
  local step

  for step_file in data/base/steps/common/*; do
    step=${step_file##*/}

    if [ ! -f _base/$LESSBIAN_DR/$step.tar.gz ]; then
      echo $(($step - 1));
      return; fi
  done; }


mkdir -p _base/$LESSBIAN_DR


last_step=$(last_packed)
echo_script "LAST STEP $last_step"


for step_file in data/base/steps/common/*; do
  step=${step_file##*/}
  echo_script "STEP $step"

  if [ $step -le $last_step ]; then
    echo_script "Already packed"; continue; fi

  if [ $step -gt 1 ]; then

    if [ ! -f "$LESSBIAN_MNT/etc/lessbian.env" ]; then
      echo_script "no env"
      unpack_base $last_step; fi

    source $LESSBIAN_MNT/etc/lessbian.env
    LESSBIAN_BASE_END_STEP=$(($LESSBIAN_BASE_END_STEP))
    LESSBIAN_BASE_START_STEP=$(($LESSBIAN_BASE_START_STEP))

    if [ $LESSBIAN_BASE_END_STEP -ge $step ]; then continue; fi

    if [ $LESSBIAN_BASE_START_STEP -gt $LESSBIAN_BASE_END_STEP ]; then
      unpack_base $last_step; fi

  fi

  report_step START $step

  echo_script "$step_file"
  ( bash $step_file; )

  report_step END $step

  pack_base $step
done

echo_script "rm -rf $LESSBIAN_MNT/*"

exit
