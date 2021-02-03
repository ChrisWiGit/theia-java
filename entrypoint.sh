#!/bin/bash

cd $WORKSPACES_HOME
gradle &

cd $WORKSPACE_HOME
yarn --cwd $USER_HOME theia start /home/workspaces --hostname=0.0.0.0 --port 3000 --plugins=local-dir:$THEIA_DEFAULT_PLUGINS