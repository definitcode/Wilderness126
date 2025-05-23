#!/bin/sh

if ! command -v git 2>&1 >/dev/null; then
	echo You must install Git to proceed
	exit 1
fi

if ! command -v node 2>&1 >/dev/null; then
	echo You must install Node to proceed
	exit 1
fi

if ! command -v bun 2>&1 >/dev/null; then
	npm i -g bun
fi

if ! command -v bun 2>&1 >/dev/null; then
	echo You must install Bun to proceed
	exit 1
fi

if ! command -v java 2>&1 >/dev/null; then
	echo You must install Java 17 or newer to proceed
	exit 1
fi

jver=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1)
if [ $jver -lt 17 ]; then
	echo You must install Java 17 or newer to proceed
	echo And it must be your primary Java version!
	exit 1
fi

index () {
	if [ ! -d engine ]; then
		startProj
		return
	fi

	echo 1. Start
	echo 2. Update
	if [ -f engine/.env ]; then
		echo 3. Reconfigure
	else
		echo 3. Configure
	fi

	read -p "" action
	if [ "$action" = "1" ]; then
		startProj
	elif [ "$action" = "2" ]; then
		updateProj
	elif [ "$action" = "3" ]; then
		reconfigureProj
	else
		clear
		echo Invalid input
		index
	fi
}

selectVer () {
	echo Please select a game version - use the number to confirm your option:
	echo 225. May 18, 2004
	echo 244. June 28, 2004

	read -p "" rev
	if [ "$rev" = "225" ]; then
		git clone https://github.com/LostCityRS/Engine-TS engine -b $rev --single-branch
		git clone https://github.com/LostCityRS/Content content -b $rev --single-branch
		git clone https://github.com/LostCityRS/Client-TS webclient -b $rev --single-branch
		index
	else
		clear
		echo Invalid input
		selectVer
	fi
}

startProj () {
	if [ ! -d engine ]; then
		selectVer
		return
	fi

	cd engine

	if [ ! -f .env ]; then
		bun install
		bun run setup
	fi

	bun start
}

updateProj () {
	cd engine
	git pull
    cd ..

	cd content
	git pull
    cd ..

	cd webclient
	git pull
	cd ..

	index
}

reconfigureProj () {
	cd engine
	bun install
	bun run setup

	cd ..
	index
}

index
