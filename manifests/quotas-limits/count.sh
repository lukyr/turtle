#let's create the ResourceQuota
kubectl create -f quota-count.yaml

#looks describe the quota-demo1
kubectl describe quota quota-demo1

#make simple a configmap
kubectl create configmap cm-demo --from-literal=name=turtle
