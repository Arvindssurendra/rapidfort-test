#!/bin/bash

set -e  # Exit the script if any command fails

# Step 1: Replace 'user www www;' with 'user daemon daemon;'
sed -i 's/user www www;/user daemon daemon;/g' /opt/bitnami/nginx/conf/nginx.conf

# Step 2: Verify that the replacement was successful
echo "Checking the nginx.conf file for the correct user directive"
if ! grep -q 'user daemon daemon;' /opt/bitnami/nginx/conf/nginx.conf; then
    echo "User replacement failed. Exiting."
    exit 1
fi

# Step 3: Add module loading directives at the top of nginx.conf
MODULE_ARRAY=('ngx_http_brotli_static_module' 'ngx_stream_geoip2_module' 'ngx_http_brotli_filter_module' 'ngx_http_geoip2_module')

for module in "${MODULE_ARRAY[@]}"; do
    if ! grep -q "load_module modules/${module}.so;" /opt/bitnami/nginx/conf/nginx.conf; then
        echo "Adding module $module to nginx.conf"
        echo "load_module modules/${module}.so;" >> /opt/bitnami/nginx/conf/nginx.conf
    fi
done

# Step 4: Validate the nginx configuration
echo "Testing the nginx configuration"
nginx -t

# Step 5: Reload nginx if the configuration is valid
if [ $? -eq 0 ]; then
    echo "Reloading nginx"
    sudo /opt/bitnami/scripts/nginx/reload.sh
else
    echo "Nginx configuration test failed"
    exit 1
fi
