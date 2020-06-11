#lets add node a taint to worker1
kubectl taint nodes kworker1.example.com key=MyTaint:NoSchedule

#We can see the taint at the node level, look at the Taints section
kubectl describe node kworker1.example.com