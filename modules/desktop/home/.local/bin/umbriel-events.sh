#!/bin/bash

command umbriel subscribe overview | while read -r line
do

	if [[ "${line}" == *'"open":true'* ]]
	then
		command noctalia msg bar-hide default
	else
		command noctalia msg bar-show default
	fi

done
