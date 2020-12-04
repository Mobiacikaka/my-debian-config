#!/bin/sh

#set -e

if [ $# = 0 ]; then
	echo Please specify a parameter!
	exit
fi

workspacelist=$(i3-msg -t get_workspaces | awk -F "},{" '
{
	for(i=1;i<=NF;i++){ print $i }
}
')

for i in $workspacelist ; do
	visible=`echo $i | awk -F"," '{print $4}'`
	name=`echo $i | awk -F"," '{print $3}' | awk -F"\"" '{print $4}'`
	true=$(echo $visible | grep true)
	if [ ! -z $true ]; then
		echo $name
		break
	fi
done

group=$((($name + 1 ) / 2))
echo $group
if [ $group = $1 ]; then
	flag=$(($name % 2))
	if [ $flag = 0 ]; then
		jump=$(($name - 1))
	else
		jump=$(($name + 1))
	fi
	echo jump to workspace $jump
	i3-msg "workspace $jump"
else
	jump=$(($1 * 2 - 1))
	echo jump to workspace $jump
	i3-msg "workspace $jump"
fi
