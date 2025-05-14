#!/bin/sh

if ! command -v git 2>&1 >/dev/null
then
	echo You must install Git to proceed
	exit 1
fi

if ! command -v node 2>&1 >/dev/null
then
	echo You must install Node to proceed
	exit 1
fi

if ! command -v java 2>&1 >/dev/null
then
	echo You must install Java 17 or newer to proceed
	exit 1
fi

jver=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1)
if test $jver -lt 17
then
	echo You must install Java 17 or newer to proceed
	echo And it must be your primary Java version!
	exit 1
fi

selectVer () {
	echo Please select a game version - use the number to confirm your option:
	echo 225. May 18, 2004
	read -p "" rev

	if test $rev -eq 225
	then
		git clone https://github.com/LostCityRS/Engine-TS engine -b $rev --single-branch
		git clone https://github.com/LostCityRS/Content engine/data/src -b $rev --single-branch
	else
		clear
		echo Invalid input
		selectVer
	fi
}

updateProj () {
	cd engine
	git pull

	cd data/src
	git pull

	cd ../../..
}

if [ ! -d engine ]; then
	selectVer
else
	updateProj
fi
