#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

URL="$1"
TIMEOUT=5


HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" --max-time $TIMEOUT "$URL")

if [[ "$HTTP_STATUS" =~ ^2 ]]; then
    echo "Application status: UP"
else
    echo "Application status: DOWN"
fi

