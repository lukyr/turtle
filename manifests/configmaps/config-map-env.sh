# Create a Prod ConfigMap
kubectl create configmap appconfigprod \
  --from-literal=DATABASE_SERVERNAME=sql.example.local \
  --from-literal=BACKEND_SERVERNAME=be.example.local

#Each creation method yeiled a different sturcture in the ConfigMap
kubectl get configmap appconfigprod -o yaml

#deploy configmap deployment
kubectl apply -f deployments/deployment-configmap-env.yaml

#let's see or configured environment variables
PODNAME=$(kubectl get pod | grep hello-world-configmap-env | awk '{print $1}' | head -n 1)
echo $PODNAME

#check environment in pod
kubectl exec -it $PODNAME -- /bin/sh -c 'printenv | sort'

#cleaning up
kubectl delete deployment hello-world-configmap-env 
kubectl delete configmap appconfigprod
