#!/bin/sh

# wrapper for lxd-cleanup

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"

cd $DIR
ENV_ID=$( python lxd.py --list | jq -r '[.[].hosts[]][0]' | xargs -I % bash -c "lxc config get % user.ansible.lxd_env_id" )

bash lxd-cleanup.sh "$ENV_ID"
