#!/usr/bin/env bash

if [[ ! -e id_rsa.test ]]; then
    ssh-keygen -f id_rsa.test
fi

docker run -v $(pwd):/src:ro --rm -it ansible ansible-playbook -i localhost, create.yml
