#!/bin/sh

##
## Counterpart to the lxd-provision.yml script
##

if [ -n "$1" ]; then
	ENV_ID="$1"
fi

if [ ! -n "${ENV_ID}" ]; then
	echo "Variable ENV_ID has to be available or an argument has to be provided" >&2
	exit 1
fi

echo "Removing environment: $ENV_ID"

for name in $(lxc list "user.ansible.lxd_env_id=$ENV_ID" --format csv -cn)
do
	echo "Stop and delete container $name"
	lxc stop "$name"
	lxc delete "$name"
done

echo "Delete profile"
lxc profile delete "$ENV_ID"

echo "Delete storage pool volumes"
curl -s --unix-socket /var/lib/lxd/unix.socket s/1.0/storage-pools/$ENV_ID/volumes | jq -r '.metadata | map(split("/")[-1])[]' | xargs -I % curl -X DELETE --unix-socket /var/lib/lxd/unix.socket s/1.0/storage-pools/$ENV_ID/volumes/image/%

echo "Delete storage"
lxc storage delete "$ENV_ID"

echo "Delete network"
lxc network delete "$ENV_ID"

exit 0
