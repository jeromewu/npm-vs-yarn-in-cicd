#!/bin/bash

N_TIMES=$1
SUM=0
TARGET=$2

export TIMEFORMAT="%R"
echo "Run $TARGET $N_TIMES times"

for (( i=1; i<=${N_TIMES}; i++ ))
do
  TIME=$(bash docker-run.sh do-run.sh $TARGET 2>&1 | tr -d '\r')
  echo "[$i]: Spend $TIME Seconds."
  SUM=$(echo "$SUM + $TIME" | bc)
  AVER=$(echo "$SUM / $i" | bc)
  echo "Average: $AVER Seconds."
done
