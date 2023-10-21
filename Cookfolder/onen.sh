#!/bin/bash
# Calculate the date 6 months ago from the current date
SIX_MONTHS_AGO=$(date -d "$current_date -6 months" "+%Y-%m-%d")

# Run the AWS CLI command to describe instances and filter by state 'stopped'
aws ec2 describe-instances --query 'Reservations[].Instances[?State.Name==`stopped`].[InstanceId,State.Name,StateTransitionReason]' --output text | \
awk -F'\t' '{gsub("User initiated \\(", "", $3); print $1, $2, $3}' | \
awk -F' ' '{print $1, $2, $3, $4}' | \
sed 's/)$//' | \
awk -v six_months_ago="$SIX_MONTHS_AGO" '$3 <= six_months_ago' | awk '{ for (i=1; i<=NF; i++) printf "%s\n", $i }' >>  rawoldec2list.txt

while read instance; read status; read date; read time;
do echo ${instance} >> oldec2list.txt;
done < rawoldec2list.txt;