#!/bin/bash
helm upgrade --install app --set image.tag=$TAG --wait ./helm/app

if [ $? == 0 ]; then
# waiting for endpoint
external_ip="";
X=1
while [ ${X} -le 15 ]

do
sleep ${X}
echo "waiting for endpoint...";
external_ip=$(kubectl get svc  myproject-sample -o jsonpath='{.status.loadBalancer.ingress[0].hostname}');

if [ -z "$external_ip" ]; then
X=$(( ${X} + 1 ))

else
echo "endpoint ready $external_ip"
break
fi
done;
else
echo "Something is wrong with the deploy. Please check"
fi
