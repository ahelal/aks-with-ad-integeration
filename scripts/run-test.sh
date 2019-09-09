#!/bin/sh
POSTFIX="$(openssl rand -hex 4)"
echo "Testing for Concourse web is up and running..."
# Test that concourse is installed and up 
if kubectl run \
        --generator=run-pod/v1 \
        -it "test-${POSTFIX}" \
        --image pstauffer/curl \
        --rm \
        --restart Never \
        -- curl concourse-web:8080/api/v1/info | grep version; then
    echo "SUCCESS CONCOURSE WEB IS INSTALLED AND RUNNING"
else
    echo "FAILED CONCOURSE WEB IS NOT RUNNING"
    exit 1
fi