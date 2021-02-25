#!/bin/bash

clustername=$1
endpoint=$2
certauth=$3
role=$4

cp -r ./webapp/eks/files/kubeconfig ./webapp/eks/files/kubeconfig_tmp
cp -r ./webapp/eks/files/config-map.yaml  ./webapp/eks/files/config-map.yaml_tmp

sed -i "s|#endpoint#|$endpoint|g" ./webapp/eks/files/kubeconfig_tmp
sed -i "s|#certauth#|$certauth|g" ./webapp/eks/files/kubeconfig_tmp
sed -i "s|#clustername#|$clustername|g" ./webapp/eks/files/kubeconfig_tmp
sed -i "s|#role#|$role|g" ./webapp/eks/files/config-map.yaml_tmp

mkdir ~/.kube/ || true

cp -r ./webapp/eks/files/kubeconfig_tmp ~/.kube/config
kubectl apply -f ./webapp/eks/files/config-map.yaml_tmp

kubectl apply -f ./webapp/eks/files/rbac-config.yaml

# deploying jenkins
helm upgrade --install jenkins --wait ./helm/jenkins

if [ $? == 0 ]; then
# waiting for endpoint
external_ip="";
X=1
while [ ${X} -le 15 ]

do
sleep ${X}
echo "waiting for endpoint...";
external_ip=$(kubectl get svc  jenkins-k8s -o jsonpath='{.status.loadBalancer.ingress[0].hostname}');

if [ -z "$external_ip" ]; then
X=$(( ${X} + 1 ))

else
echo -e "\033[1mendpoint ready $external_ip\033[0m"
break
fi
done;
else
echo "Something is wrong with the deploy. Please check"
fi
