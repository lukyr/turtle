# Create a QA configMap
#We can source our ConfigMap from files or from directories
#If no key, then the base name of the file
#Otherwose we can speify a key name to allow for more coplex app configs and access to specific configuration 
#entry your file with:
#files/appconfigqa 
#DATABASE_SERVERNAME=sqlqa.example.local
#BACKEND_SERVERNAME=beqa.example.local
kubectl create configmap appconfigqa \
  --from-file=files/appconfigqa

#Each creation method yeiled a different sturcture in the ConfigMap
kubectl get configmap appconfigqa -o yaml

#deploy configmap deployment
kubectl apply -f deployments/deployment-configmap-file.yaml

#let's see or configured environment variables
PODNAME=$(kubectl get pod | grep hello-world-configmap-file | awk '{print $1}' | head -n 1)
echo $PODNAME

#check environment in pod
kubectl exec -it $PODNAME -- /bin/sh -c 'more /etc/appconfig/appconfigqa'

#updating a configmap
kubectl edit configmap appconfigqa

kubectl exec -it $PODNAME -- /bin/sh
watch cat /etc/appconfig/appconfigqa
exit

#cleaning up
kubectl delete deployment hello-world-configmap-file 
kubectl delete configmap appconfigqa

