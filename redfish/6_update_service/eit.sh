#!/bin/bash
#rfip=172.17.10.7:8888
#rfip=172.17.8.122:8888
#rfip=172.17.8.238:8888
rfip=172.17.8.41:8888
#rfip=172.17.8.5:8888
#Enable seesion service#
listener=172.17.8.60:8889
#update_server=172.17.8.103
update_server=
curl --insecure -X POST -D headers.txt https://${rfip}/redfish/v1/SessionService/ -d '{"ServiceEnabled":true,"SessionTimeout":600}'
robot  -v OPENBMC_HOST:${rfip} -v LISTENER_HOST:${listener} -v UPDATE_SERVER:${update_server} ./
