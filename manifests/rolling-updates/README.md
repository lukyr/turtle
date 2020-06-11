## Rolling updates
allow Deployments’ update to take place with zero downtime by incrementally updating Pods instances with new ones. The new Pods will be scheduled on Nodes with available resources.

### Using Rolling Update Strategy
```
...
strategy:
  type: RollingUpdate
  rollingUpdate:
     maxUnavailable: 25%
     maxSurge: 1
```

#### maxUnavailable
* is an optional field that specifies the maximum number of Pods that can be unavailable during the update process. The value can be an absolute number (for example, 5) or a percentage of desired Pods (for example, 10%). The absolute number is calculated from percentage by rounding down. The value cannot be 0 if maxSurge is 0. The default value is 25%.
#### maxSurge
* is an optional field that specifies the maximum number of Pods that can be created over the desired number of Pods. The value can be an absolute number (for example, 5) or a percentage of desired Pods (for example, 10%). The value cannot be 0 if MaxUnavailable is 0. The absolute number is calculated from the percentage by rounding up. The default value is 25%.

### Notice
that there maybe a little downtime on your application because the old pods are getting terminated and the new ones are getting created. The fix is pretty easy actually. This happens because kubernetes doesn’t know when your new pod is ready to start accepting requests. To do this, Kubernetes provide a config option in deployment called Readiness Probe.
```
containers:
...
readinessProbe:
  httpGet:
    path: /
    port: 8080
    initialDelaySeconds: 5
    periodSeconds: 5
    successThreshold: 1
```
* initialDelaySeconds: Number of seconds after the container has started before readiness probes are initiated.
* periodSeconds: How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.
* timeoutSeconds: Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1.
* successThreshold: Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness. Minimum value is 1.
* failureThreshold: When a Pod starts and the probe fails, Kubernetes will try failureThreshold times before giving up. Giving up in case of liveness probe means restarting the Pod. In case of readiness probe the Pod will be marked Unready. Defaults to 3. Minimum value is 1.