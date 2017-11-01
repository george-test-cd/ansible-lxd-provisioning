#!/bin/sh

set -e

if [ ! -n "$1" ]; then
	echo "Requires at least one parameter (playbook?)" >&2
	exit 1
fi

DIR="$( cd "$( dirname "$0" )" && pwd )"

chmod +x "$DIR"/lxd.py

ansible-playbook -i $DIR/lxd.py "$@"