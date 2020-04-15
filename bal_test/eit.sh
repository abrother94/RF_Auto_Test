#!/bin/bash

if [ "$1" == "GPON" ];then
  echo "GPON Testing"
  rfip=172.17.8.6:8888
  curl --insecure -X POST -D headers.txt https://${rfip}/redfish/v1/SessionService/ -d '{"ServiceEnabled":true,"SessionTimeout":600}'
  robot  -v OPENBMC_HOST:${rfip} -v PON_TYPE:GPON -v SPECIFIC_ID:ISKT -v SPECIFIC_NUM:428DA323  -v PON_PORT_ID:2 ./ 
elif [ "$1" == "XGSPON" ];then
  echo "XGSPON Testing"
  rfip=172.17.8.238:8888
  curl --insecure -X POST -D headers.txt https://${rfip}/redfish/v1/SessionService/ -d '{"ServiceEnabled":true,"SessionTimeout":600}'
  robot  -v OPENBMC_HOST:${rfip} -v PON_TYPE:XGSPON -v SPECIFIC_ID:ISKT -v SPECIFIC_NUM:71E80110  -v PON_PORT_ID:1 ./ 
fi
