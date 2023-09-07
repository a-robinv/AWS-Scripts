#!/bin/bash

aws backup list-recovery-points-by-backup-vault \
--backup-vault-name ossbackup_12am \
--by-created-before '2023-08-01T00:00:00+00:00' \
--region ap-southeast-1 \
--query 'RecoveryPoints[].RecoveryPointArn' \
--output text \
| awk '{ for (i=1; i<=NF; i++) printf "%s\n", $i }' \
>> recoverypointsbeforeaugust.txt

while read AmiARN;
do aws backup delete-recovery-point \
--region ap-southeast-1 \
--backup-vault-name ossbackup_12am \
--recovery-point-arn ${AmiARN};
done < recoverypointsbeforeaugust.txt