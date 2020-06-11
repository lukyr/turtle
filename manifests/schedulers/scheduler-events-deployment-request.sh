#Let's create a deployment with 3 replicas
kubectl apply -f deployment-request.yaml

#Pods spread out evenly across the Node due to our scoring functions for selector spread during Scoring.
kubectl get pods -o wide

#We can look at the Pods events to see the scheduler making its choice
#The Scheduler can't find a place in this cluster to plcae our workload 
kubectl describe pods

#Clean up deployment
kubectl delete deployment hello-world-request