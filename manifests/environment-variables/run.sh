#Passing Configuration into containers using environment variables
#Create two deployments, one for a database system and the other our application
#Putting a little wait in there so the pods are created one after the other.
kubectl apply -f deployments/deployment-alpha.yaml
sleep 5
kubectl apply -f deployments/deployment-beta.yaml

#Let's look at the service
kubectl get service

#Now Lets get the name of one of our pods
PODNAME=$(kubectl get pods | grep hello-world-alpha | awk '{print $1}' | head -n 1)
echo $PODNAME

#Inside the Pod, lets read the environment variables from our container
#Notice the alpha information is there but not the beta information. since beta wasn't defined when the Pod started.
kubectl exec -it $PODNAME -- /bin/sh -c "printenv | sort"

# delete pods
kubectl delete -f deployments/deployment-alpha.yaml
sleep 5
kubectl delete -f deployments/deployment-beta.yaml