#!/usr/bin/env bash

##
# Inspect source code with rubocop. Do not change .rubocop_todo.yml.
#
# To check your changes in source code, run:
#   ./check-syntax.sh
#
# To inspect all errors that should be fixed run:
#   rubocop
#
# This will return all errors hidden by todo file. Errors should be fixed,
# then manualy removed from .rubocop_todo.yml
##

rubocop --format simple --config .rubocop_todo.yml
