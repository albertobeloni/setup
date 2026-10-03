#!/bin/bash

if [[ "${-}" != *i* ]]
then
	return
fi

if command test -r "${XDG_CONFIG_HOME}/bash/profile"
then
	command source "${XDG_CONFIG_HOME}/bash/profile"
fi
