#!/bin/bash
##############################################################
##  In here you add whatever action should happen after the container ha been created
##  such as exposing the application.
##############################################################
#Load the functions into the shell
source /workspaces/$RepositoryName/.devcontainer/util/functions.sh

# Expose Mkdocs
exposeMkdocs

printInfoSection "Your dev.container finished starting."