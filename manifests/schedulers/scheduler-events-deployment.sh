#Let's create a deployment with 3 replicas
kubectl apply -f deployment.yaml

#Pods spread out evenly across the Node due to our scoring functions for selector spread during Scoring.
kubectl get pods -o wide

#We can look at the Pods events to see the scheduler making its choice
kubectl describe pods

#Make scale our deployment to 6
kubectl scale deployment hello-world --replicas=6

#We can see the nodeName populated for this node.
PODNAME=$(kubectl get pod | grep hello-world | awk '{print $1}' | head -n 1 )
kubectl get pod $PODNAME -o yaml

#Clean up deployment
kubectl delete deployment hello-world