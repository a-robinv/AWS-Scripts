read -p "Enter Priority, P3 for stg, P2 for prd " PRIORITY

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
done < lblist.txt;