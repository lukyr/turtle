#Let's test out anti-affinity, deploy web and cache again
#But this time we're going to make sure that no more than web pod is on each node with anti-affinity
kubectl apply -f deployment-antiaffinity.yaml
kubectl get pods -o wide

#Now lets scale the replicas in the web and cache deployment
kubectl scale deployment hello-world-web --replicas=3

#One Pod will go pending because we can have only 1 web per node
#When using requiredDuringSchedulingIgnoredExecuting in our antiaffinity rule
kubectl get pods -o wide --selector app=hello-world-web

#To 'fix' this we can change the scheduling rule to prefferedDuringSchedulingIgnoredDuringExecuting
#Also going to set the number of replicas to 3
