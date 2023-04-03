#!/bin/bash

welcome_message(){
    cat << EOF

Welcome to use the working environment

This docker environment is set up for the Computer Organization course
All projects are in the /workspace/projects directory

EOF
}

source /Docker/env_setup.sh

# setup personal repo
git config --global user.name $GIT_NAME
git config --global user.email $GIT_EMAIL
git config --global core.editor vim

sudo chown -R "$(id -un)":"$(id -un)" /workspace


welcome_message
echo the workspace is created.
