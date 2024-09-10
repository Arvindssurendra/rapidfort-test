#!/bin/bash

set -x
set -e

/opt/bitnami/scripts/nginx/reload.sh

/opt/bitnami/scripts/nginx/status.sh