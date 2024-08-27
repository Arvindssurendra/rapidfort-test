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

#!/bin/bash

set -x
set -e

# Update the Nginx user to a valid one
sed -i 's/user www;/user nginx;/' /opt/bitnami/nginx/conf/nginx.conf

declare -a MODULE_ARRAY=("ngx_http_brotli_static_module" "ngx_stream_geoip2_module" "ngx_http_brotli_filter_module" "ngx_http_geoip2_module");
for module in "${MODULE_ARRAY[@]}"
do
    echo "load_module modules/${module}.so;" | cat - /opt/bitnami/nginx/conf/nginx.conf > /tmp/nginx.conf && \
        cp /tmp/nginx.conf /opt/bitnami/nginx/conf/nginx.conf
done

/opt/bitnami/scripts/nginx/reload.sh
/opt/bitnami/scripts/nginx/status.sh
