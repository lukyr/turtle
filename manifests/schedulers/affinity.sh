#Let's start off with a deployment of web cache pods
#Affinity: we want to have always have a cache pod co-located on a Node where we a Web Pod
kubectl apply -f deployments/deployment-affinity.yaml

#Let's checkout the labels on the nodes, look for kubernetes.io/hostname which
#we're using for our topologykey
kubectl describe nodes kworker1 | head
kubectl get nodes --show-labels

#If we can see that web and cache are both on the same node.
kubectl get pods -o wide

#If we scale the web deployment
#We'all still get spread across nodes in the ReplicaSet, so don't need to enforce that with affinity
kubectl scale deployment hello-world-web --replicas=2
kubectl get pods -o wide

#Then When we scale the cache deployment, it will get sheduled to the same node as the other web server
#hello-world-cache pod will always get scheduled to a node where a hello-world-web pod is already up and running
kubectl scale deployment hello-world-cache --replicas=2
kubectl get pods -o wide

#clean up the resources from these deployments
kubectl delete -f deployment-affinity.yaml