## ConfigMaps
* Key value pairs exposed into a Pod used application configuration settings
* Defining application or environment specific settings
* Decouple application and Pod configurations
* Maximzing our container image's portablility
* Environment Variables or Files

## Using ConfigMaps in Pods
### Environment variables
* valueFrom and envFrom
### Volumes and Files
* Volume mounted inside a container
* Single file or directory
* Many files or directories
* Volume ConfigMaps can be updated

## Defining ConfigMaps
define variables:
```
kubectl create configmap appconfigprod \
--from-literal=DATABASE_SERVERNAME=sql.example.local
--from-literal=BACKEND_SERVERNAME=be.example.local
```
define files :
```
kubectl create configmap appconfigqa
--from-file=appconfigqa
```
define manifest
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: appconfigprod
  data:
    BACKEND_SERVERNAME: be.example.local
    DATABASE_SERVERNAME: sql.example.local
```
## Using ConfigMaps in Environment Variables
```
spec:
  containers:
  - name: hello-world
    ...
    env:
    - name: DATABASE_SERVERNAME
      valueFrom:
        configMapKeyRef:
          name: appconfigprod
          key: DATABASE_SERVERNAME
    - name: BACKEND_SERVERNAME
      valueFrom:
        configMapKeyRef:
          name: appconfigprod
          key: BACKEND_SERVERNAME
```
or
```
containers:
  - name: hello-world
    ...
    envFrom:
      - configMapRef:
        name: appconfigprod
```
## Using ConfigMaps as Files
```
spec:
  volumes:
    - name: appconfig
      configMap: 
        name: appconfigqa
  containers:
    - name: hello-world
      ...
      volumeMounts:
        - name: appconfig
          mountPath: "/etc/appconfig"

```