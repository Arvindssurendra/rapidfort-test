#!/bin/bash

# Enable debug mode and fail on errors
set -x
set -e

# List Apache modules directory (optional for debugging)
ls /opt/bitnami/apache2/modules/

# List currently loaded Apache modules (optional for debugging)
httpd -M

# Backup the current httpd.conf file (in case you need to restore it later)
cp /opt/bitnami/apache2/conf/httpd.conf /opt/bitnami/apache2/conf/httpd.conf.bak

# Ensure 'mod_unixd' is loaded by retaining it and commenting out other LoadModule lines
sed -i '/LoadModule unixd_module/!s/^LoadModule/#LoadModule/' /opt/bitnami/apache2/conf/httpd.conf

# Check if mod_unixd is already present; if not, add it manually
if ! grep -q 'LoadModule unixd_module' /opt/bitnami/apache2/conf/httpd.conf; then
  echo "LoadModule unixd_module modules/mod_unixd.so" >> /opt/bitnami/apache2/conf/httpd.conf
fi

# Append your custom module list to the configuration file
cat /opt/bitnami/scripts/modules_list >> /opt/bitnami/apache2/conf/httpd.conf

# Optionally, display the updated configuration for review (commented out by default)
# cat /opt/bitnami/apache2/conf/httpd.conf

# Reload Apache to apply the new configuration
/opt/bitnami/scripts/apache/reload.sh

# Check Apache status to verify it has successfully reloaded
/opt/bitnami/scripts/apache/status.sh

# List loaded Apache modules after the reload (optional for debugging)
httpd -M
