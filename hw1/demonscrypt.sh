#!/bin/bash

CONF_DIR="/etc/LogCleaner"
DIR_LIST="dirs.list"

function remove_files() {
	if (($# < 1)); then
		return
	fi
	files=`ls $1`
	dir=$1
	for file in $files; do
		if [[ -d "$1/$file" ]]; then
			remove_files "$1/$file"
		elif [[ -h "$1/$file" ]]; then
			continue
		else
			rm "$1/$file"
		fi
	done
}

if [[ ! -d $CONF_DIR ]]; then
	mkdir $CONF_DIR
fi

if [[ ! -d $CONF_DIR$DIR_LIST ]]; then
	echo "/var/log" > $CONF_DIR$DIR_LIST 
fi

files_list=()
while IFS= read -r line; do
	files_list+=("$line")
done < "$CONF_DIR$DIR_LIST"

while :
do
	for filename in "${files_list[@]}"; do
		echo "$filename"
		remove_files $filename
	done
	sleep 5m
done
