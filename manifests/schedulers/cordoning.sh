kubectl cordon kworker1

#lets create d deployment with 3 replicas
kubectl apply -f deployments/deployment-cordoning.yaml

#Pods spread out evenly across the nodes
kubectl get pods -o wide

#Let's drain (remove) the pods from kworker1
kubectl drain kworker1

#remove cordon of node
kubectl uncordon kworker1.example.com