#!/bin/bash
set -e

CLOUDFLARE_NGX_CONFIG="${1}"
ngx_append() { echo "$1" >> $CLOUDFLARE_NGX_CONFIG; }

if [ -z "$CLOUDFLARE_NGX_CONFIG" ]; then
	echo "Usage: $0 <path to nginx config>"
	exit 1
fi

if [ -f "$CLOUDFLARE_NGX_CONFIG" ]; then
	rm $CLOUDFLARE_NGX_CONFIG
fi

touch $CLOUDFLARE_NGX_CONFIG
ngx_append "# Cloudflare IP Ranges"
ngx_append "# https://www.cloudflare.com/ips/"
ngx_append ""

ngx_append "# Cloudflare IPv4"
for i in `curl -s -L https://www.cloudflare.com/ips-v4`; do
	ngx_append "set_real_ip_from $i;"
done

ngx_append ""
ngx_append "# Cloudflare IPv6"
for i in `curl -s -L https://www.cloudflare.com/ips-v6`; do
	ngx_append "set_real_ip_from $i;"
done

ngx_append ""
ngx_append "real_ip_header CF-Connecting-IP;"
