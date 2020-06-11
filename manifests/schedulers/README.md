## Scheduling in Kubernetes
* Selecting a Node to start a Pod on

## Scheduling Proccess
* --> Watches the API Server for Unscheduled Pods 
* --> Node Selection 
* --> Update nodeName in the Pod Object 
* --> Nodes' kubelet watch API Server for Work 
* --> Signal container runtime to start conainer(s) 

## Node Selection
### Filtering
* From all Nodes
* Apply Filter
* Filtered Nodes
* Hard Constraint
### Scoring
```
Scoring will evaluate a collection of scoring function to get priority wait to find the most appropriate place to run
```
* Scoring Function 
* Feasible Nodes
* Policy constraints
### Binding
* Selected Nodes List
* Ties are broken
* Update API Object

## Resource Requests
* Setting requests will cause the sheduler to find a Node to fit the workload/Pod
```
request are guarantees 
* CPU
* Memory
```
* Allocatable resources per Node
* Pods Needing to be scheduled while there are not enough resources available will go pending

## Controlling Scheduling
### Node Selector
* nodeSelector - assign Pods to Nodes using Labels and Selectors
* Apply Labels to Nodes
* Scheduler will assign Pods a to a Node with a matching label
* Simple key/value check based on matchLabels
* Often used to map Pods to Nodes based on (Special hardware requirements & Workload isolation)

Example 
Assigning Pods to Nodes using Node Selectors

```
kubectl label node worker1 hardware=local_gpu

spec:
  containers:
  - name: hello-world
    image: gcr.io/google-samples/hello-app:1.0
    ports:
    - containerPort: 8080
  nodeSelector:
    hardware: local_gpu

```

### Affinity and anti-Affinity
* nodeAffinity - uses Labels on Nodes to make scheduling decision with matchExpressions 
(requiredDuringSchedulingIgnoredDuringExecution & prefferedDuringShedulingIgnoredDuringExecution)
```
spec:
  containers:
  - name: hello-world-cache
  ...
  affinity:
    podAffinity:
      requiredDuringShedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - hello-world-web
        topologyKey: "kubernetes.io/hostname"
```
* podAffinity - schedule Pods onto the same Node, Zone as some other Pod
* podAntiAffinity - schedule Pods onto the different Node, Zone as some other Pod

## Node Cordoning
* Marks a Node as unschedulable
* Prevents new Pods from being scheduled to that Node
* Does not affect any existing Pods on the Node
* This is useful as a preparatory step before a Node reboot or maintenance
```
kubectl cordon kworker1
```
* If you want to gracefully evict your pods from a Node
```
kubectl drain kworker1 --ignore-daemonsets
```

## Manually Scheduling a Pod
* Scheduler populates nodeName
* If you specify nodeName in your Pod Definition the Pod will be started on that node
* Node's name must exist
* Still subject to Node resource constraints

## Configuring Multiple Schedulers
* Implement your own scheduler 
* Run multiple schedulers concurrently
* Define in your Pod Spec which scheduler you want
* Deploy your scheduler as a system Pod in the cluster