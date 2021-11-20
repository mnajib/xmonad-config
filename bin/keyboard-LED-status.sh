#!/usr/bin/env bash

# log pid
#echo $$

s=""
onColor="#ffffff"
offColor="#646464"

while true; do
    s=`xset -q | egrep '[0-9][0-9]:' | sed 's/[0-9][0-9]: /\n/g' | sed 's/\n//g' | grep 'Lock:' | sed 's/ Lock:/:/g' | sed 's/\ *//g' | sed -e "/on/ s,^,<fc=${onColor}>,; /off/ s,^,<fc=${offColor}>,; s,:.*$,<\/fc>," | tr '\n' ' ' | sed 's/$/\n/g'`

    echo "$s"
    sleep 1
done

# XXX: TODO?
#xxkb
