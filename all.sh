#!/bin/bash
####################################
rfip=172.17.8.122:8888
listener=172.17.10.60:8889
FirmwareVersion=2.1.3.59.21
####################################
rm -rf log*;output.xml;report.html
curl --insecure -X POST -D headers.txt https://${rfip}/redfish/v1/SessionService/ -d '{"ServiceEnabled":true,"SessionTimeout":600}'
robot -v OPENBMC_HOST:${rfip} -v LISTENER_HOST:${listener} -v FWV:${FirmwareVersion} redfish/
