#!/usr/bin/env bash

docker run -v $(pwd):/src:ro --rm -it ansible ansible-playbook -i localhost, playbook-destroy.yml
