#!/bin/sh

# setup lxd containers

set -e

if [ -n "$1" ]; then
	LXD_ENV_DEFINITION_FILE="$1"
fi

if [ ! -n "${LXD_ENV_DEFINITION_FILE}" ]; then
	echo "Variable LXD_ENV_DEFINITION_FILE has to be available or an argument has to be provided" >&2
	exit 1
fi

LXD_ENV_ID="${GO_PIPELINE_NAME}-${GO_PIPELINE_COUNTER}"

# network name is limited to 15 characters
LXD_NETWORK_NAME="$(echo $GO_PIPELINE_NAME | cut -c1-"$(( 14 - ${#GO_PIPELINE_COUNTER} ))")-${GO_PIPELINE_COUNTER}"

DIR="$( cd "$( dirname "$0" )" && pwd )"

echo "Creating LXD containers for environment ${LXD_ENV_ID} with network ${LXD_NETWORK_NAME}"

cd "$DIR"

cat >lxd.ini <<EOL
[lxd]
resource = user.ansible.lxd_env_id=${LXD_ENV_ID}
EOL

ansible-playbook -i "localhost" -c local lxd-provision.yml -e "lxd_env_definition='${LXD_ENV_DEFINITION_FILE}' lxd_env_id='${LXD_ENV_ID}' lxd_network_name='${LXD_NETWORK_NAME}'"
/bin/sh gocd-lxd-ansible-playbook.sh install-python.yml configure-sudo.yml install-basic-tools.yml 

