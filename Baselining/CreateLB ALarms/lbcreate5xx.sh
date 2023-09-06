read -p "Enter Priority, P3 for stg, P2 for prd " PRIORITY

# Generate ARN of LBs
aws elbv2 describe-load-balancers --region ap-southeast-1 --query "LoadBalancers[].LoadBalancerArn" --output text \
| awk '{ for (i=1; i<=NF; i++) printf "%s\n", $i }' > arnlist.txt

# string manip

sed -i 's/arn:aws:elasticloadbalancing:ap-southeast-1:811348665611:loadbalancer\///g' arnlist.txt

#For custom Priorities for stg and prd environment, use grep to differentiate the arnlist, and run by environment

#starts cw alarms screation
while read LB;
do aws cloudwatch put-metric-alarm \
    --alarm-name "JFC-DT - $PRIORITY - Critical Sum of 5xx errors on $LB" \
    --alarm-description "Sum of 5xx errors on {$LB} is greater than 0" \
    --metric-name HTTPCode_ELB_5XX_Count \
    --namespace AWS/ApplicationELB \
    --statistic Sum \
    --period 300 \
    --treat-missing-data notBreaching \
    --threshold 0 \
    --comparison-operator GreaterThanThreshold \
    --dimensions Name='LoadBalancer',Value=\'{$LB}\' \
    --evaluation-periods 1 \
    --alarm-actions arn:aws:sns:ap-southeast-1:811348665611:ECV-MSP-Support \
    --unit Count \
    --region ap-southeast-1;
done < arnlist.txt;