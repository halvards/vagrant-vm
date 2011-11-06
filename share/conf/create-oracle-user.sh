#!/bin/bash

source /root/.bashrc

GEN_ERR=1
/u01/app/oracle/product/11.2.0/xe/bin/sqlplus -l -s system/password @create-user.sql

if [ $? -ne 0 ]
then
echo "Running sqlplus FAILED"
exit ${GEN_ERR}
fi
