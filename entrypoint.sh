#!/bin/bash
set -o pipefail

# Create /root/.edgerc file from env variable
echo -e "${AKAMAI_EDGERC}" > ~/.edgerc

#  Set Variables
zoneName=$1

# update zone using HTTPie and https://developer.akamai.com/api/cloud_security/edge_dns_zone_management/v2.html#postchangelistrecordsets

# check if zone file exists
if [ -f ${zoneName}.zone ] ; then 
  echo "Zone file exists: ${zoneName}.zone"
else
  echo "Error: ${zoneName}.zone is missing" && exit 123
fi 

# response=$(http edgeworkers list-ids --json --section edgeworkers --edgerc ~/.edgerc)
echo "1. uploading zone file"
mycommand1="http --print=HhbB -A edgegrid -a dns: POST :/config-dns/v2/zones/${zoneName}/zone-file Content-Type:text/dns < ${zoneName}.zone"
echo "Running: $mycommand1"
eval $mycommand1 > output1
status=$(cat output1 | grep 'HTTP/1.1 ' | awk '{print $2}')
if [ $status -eq "204" ] ; then
  # Extract eTag value
  versionID=$(cat output1 | grep 'ETag:' | sed 's/"//g' | awk '{print $2}')
  echo -e "Zone file accepted!\nZone version: ${versionID}\n"
else
  echo -e "Error: Status code=${status} (expected 204)\nAPI response:" 
  tail -1 output1 | jq .
  exit 123
fi

# Check status of new version
echo "2. Checking activation status"
mycommand2="http --print=HhbB -A edgegrid -a dns: GET :/config-dns/v2/zones/${zoneName}/versions/${versionID}"
echo "Running: $mycommand2"
eval $mycommand2 > output2
status=$(tail -1 output2 | jq -r .activationState)
apibody=$(tail -1 output2 | jq .)
echo -e "API response:\n${apibody}"

if [ $status = "PENDING" ] ; then
  # do something like send a slack message indicating zone started activating, activation ETA is around 5min
  echo "Zone is activating (most activations take less than 5 minutes to complete)" 
  # don't loop to check if version is active to avoid consuming GitHub runner minutes
  exit 0
fi