#!/usr/bin/env python

import os
from subprocess import Popen, PIPE
import json
import sys

lxd_env_id = os.environ.get('GO_PIPELINE_NAME') + "-" + os.environ.get('GO_PIPELINE_COUNTER')
resource_filter = "user.ansible.lxd_env_id=" + lxd_env_id

pipe = Popen(['lxc', 'list', resource_filter, '--format', 'json'], stdout=PIPE, universal_newlines=True)
lxdjson = json.load(pipe.stdout)

if len(lxdjson)!=1:
        sys.exit('Expecting single container')

if lxdjson[0]['config']['user.ansible.groups']!="app,web":
        sys.exit('Ansible groups are not matching')

if lxdjson[0]['config']['user.ansible.lxd_env_id']!=lxd_env_id:
        sys.exit('Ansible env_id is not matching')

print "All good"