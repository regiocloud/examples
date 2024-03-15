#!/usr/bin/env bash

docker run -v $(pwd):/src:ro --rm -it ansible ansible-playbook -c local -i localhost, destroy.yml
