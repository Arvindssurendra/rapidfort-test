# #!/bin/bash

# set -x
# set -e

# declare -a MODULE_ARRAY=("ngx_http_brotli_static_module" "ngx_stream_geoip2_module" "ngx_http_brotli_filter_module" "ngx_http_geoip2_module");
# for module in "${MODULE_ARRAY[@]}"
# do
#     echo "load_module modules/${module}.so;" | cat - /opt/bitnami/nginx/conf/nginx.conf > /tmp/nginx.conf && \
#         cp /tmp/nginx.conf /opt/bitnami/nginx/conf/nginx.conf
# done

# /opt/bitnami/scripts/nginx/reload.sh

# /opt/bitnami/scripts/nginx/status.sh


### sucuss notification

#!/bin/bash

# set -x
# # set -e

# # # Ensure the 'daemon' user is used in nginx.conf instead of 'www'
# # sed -i 's/user www;/user daemon daemon;/g' /opt/bitnami/nginx/conf/nginx.conf

# # declare -a MODULE_ARRAY=("ngx_http_brotli_static_module" "ngx_stream_geoip2_module" "ngx_http_brotli_filter_module" "ngx_http_geoip2_module")
# # for module in "${MODULE_ARRAY[@]}"
# # do
# #     echo "load_module modules/${module}.so;" | cat - /opt/bitnami/nginx/conf/nginx.conf > /tmp/nginx.conf && \
# #         cp /tmp/nginx.conf /opt/bitnami/nginx/conf/nginx.conf
# # done

# # # Validate and reload Nginx configuration
# # nginx -t && /opt/bitnami/scripts/nginx/reload.sh

# # /opt/bitnami/scripts/nginx/status.sh


#!/bin/bash

set -x  # Enable debug mode
set -e  # Exit on errors

# Replace 'user www;' with 'user daemon daemon;'
# sed -i 's/user www;/user daemon daemon;/g' /opt/bitnami/nginx/conf/nginx.conf

# Print the file to verify the user directive is changed
cat /opt/bitnami/nginx/conf/nginx.conf

# Load the Nginx modules
MODULE_ARRAY=('ngx_http_brotli_static_module' 'ngx_stream_geoip2_module' 'ngx_http_brotli_filter_module' 'ngx_http_geoip2_module')

for module in "${MODULE_ARRAY[@]}"; do
    if ! grep -q "load_module modules/${module}.so;" /opt/bitnami/nginx/conf/nginx.conf; then
        echo "load_module modules/${module}.so;" | cat - /opt/bitnami/nginx/conf/nginx.conf > /tmp/nginx.conf && \
        cp /tmp/nginx.conf /opt/bitnami/nginx/conf/nginx.conf
    fi
done


# Test Nginx configuration
nginx -t
if [ $? -eq 0 ]; then
    # Reload Nginx if the configuration is valid
    /opt/bitnami/scripts/nginx/reload.sh
else
    echo "Nginx configuration is invalid."
    exit 1
fi

/opt/bitnami/scripts/nginx/status.sh
