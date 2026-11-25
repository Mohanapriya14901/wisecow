
#!/bin/bash

# Get application URL
url=${1:-https://wisecow.local}

log_file="application-health.log"

# Check HTTP status code
status_code=$(curl -s -o /dev/null -w "%{http_code}" \
    --connect-timeout 5 --max-time 10 \
    --cacert ../../wisecow-tls/tls.crt "$url")

echo "----- Application Health Checker -----"
echo "Date: $(date)"
echo "Application URL: $url"
echo "HTTP Status Code: $status_code"

# Check application status
if [ "$status_code" = "200" ]; then
    echo "Application is UP"
    echo "$(date): $url - UP ($status_code)" >> "$log_file"
else
    echo "Application is DOWN"
    echo "$(date): $url - DOWN ($status_code)" >> "$log_file"
fi

echo "--------------------------------------"
echo "Result saved to $log_file"
