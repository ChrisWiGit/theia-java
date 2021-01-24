#!/bin/bash

cd $WORKSPACES_HOME
gradle &

cd $USER_HOME
yarn theia start /home/workspaces --hostname=0.0.0.0 --port 3000