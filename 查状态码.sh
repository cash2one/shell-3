#!/bin/bash

curl -s -I "$1" -o /dev/null -w %{http_code} -x "$2"
