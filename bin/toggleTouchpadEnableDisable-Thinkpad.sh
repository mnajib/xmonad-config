#!/usr/bin/env bash

# Try disabling the libinput device.
#xinput list
d=`xinput list | grep -i touchpad | awk '{for(i=1;i<=NF;i++){ tmp=match($i, /id=[0-9]/); if(tmp){print $i} } }' | awk --field-separator== '{ print $2 }'`
#echo 'xinput list | grep -i touchpad | awk '{for(i=1;i<=NF;i++){ tmp=match($i, /id=[0-9]/); if(tmp){print $i} } }' | awk --field-separator== '{ print $2 }''
echo 'xinput list'
echo "  SynPS/2 Synaptics TouchPad device ID: $d"

# Find the touchpad, in my case it's called "SynPS/2 Synaptics TouchPad", with ID 11.
# xinput list-props <ID or name>
echo "xinput list-props $d"
de=`xinput list-props $d | grep 'Device Enabled' | awk '{ print $3}' | awk --field-separator=\( '{print $2}' | awk --field-separator=\) '{print $1}'`
ds=`xinput list-props $d | grep 'Device Enabled' | awk '{ print $4}'`
echo "  Device Enabled setting ID: $de, Device Enabled status: $ds"
df=`xinput list-props $d | grep 'Tapping Enabled (' | awk '{ print $4}' | awk --field-separator=\( '{print $2}' | awk --field-separator=\) '{print $1}'`
dg=`xinput list-props $d | grep 'Tapping Enabled (' | awk '{ print $5}'`
echo "  Tapping Enabled setting ID: $df, Device Enabled status: $dg"

enable=1
disable=0

newStatus=0
newTappingStatus=0
if [ $ds == 0 ]; then
  echo "Current touch status: disable. We will enable it."
  newStatus=$enable
  newTappingStatus=$disable  
  echo "Toggle status"
  xinput set-prop $d $de $newStatus
  xinput set-prop $d $df $newTappingStatus
elif [ $ds == 1 ]; then
  echo "Current touch status: enable. We will disable it."
  newStatus=$disable
  newTappingStatus=$disable
  echo "Toggle status"
  xinput set-prop $d $de $newStatus
  #xinput set-prop $d $df $newTappingStatus
fi

# There should be one called 'Device Enabled'; at least mine has.
# xinput set-prop <device ID/name> <setting ID/name> 0
#echo "xinput set-prop $d $de $newStatus"
#echo "Toggle status"
#xinput set-prop $d $de $newStatus
#xinput set-prop $d $df $newTappingStatus

# query new status
ds2=`xinput list-props $d | grep 'Device Enabled' | awk '{ print $4}'`
echo "  Device Enabled setting ID: $de, Device Enabled status: $ds2"
dg2=`xinput list-props $d | grep 'Tapping Enabled (' | awk '{ print $5}'`
echo "  Tapping Enabled setting ID: $df, Device Enabled status: $dg2"

# Will disable the device (even the buttons). Set in startup script if necessary, and hope that Gnome doesn't override the setting, ugh. :)
