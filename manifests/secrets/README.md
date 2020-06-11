Secrets
 - Store sensitive information as Object
 - Retrive for later use
 - Passwords, API tokens, keys and certificates
 - Safer and more flexible configurations (Pod specs and images)

 Properties of Secrets
 - Base64 encoded
 - Encryption can be configured
 - Stored in etcd
 - Namespaced and can only be referenced by Pods in the same Namespace
 - Unavailable secrets will prevent a Pod from starting up

 How Using Secrets in Pods
 - Environtment Variables
 - Volumes or Files
 - Referenced Secret must be created and accessible for the Pod to start up

 Creating Secrets

 kubectl create secret generic app1 \
 --from-literal=USERNAME=app1login \
 --from-literal=PASSWORD='S0methingS@Str0ng!'

 Using secrets in Environment Variables
 spec:
    containers:
    - name: hello-world
    ...
    env:
    - name: app1username
        valueFrom:
        secretKeyRef:
            name: app1
            key: USERNAME
    - name: app1password
        valueFrom:
        secretKeyRef:
            name: app1
            key: PASSWORD
        
Using Secrets as Files
spec:
    volumes:
    - name: appconfig
      secret: 
        secretName: app1
    containers:
    ...
      volumeMounts:
        - name: appconfig
          mountPath: "/etc/appconfig"
          // it will be 
          /etc/appconfig/USERNAME
          /etc/appconfig/PASSWORD

Accessing a Private Container Registry
- Secret for application configuration
- Use Secrets to access a private container registry
- Want to access registries over the internet (Docker hub & Cloud based container registries)
- Create a Secret of type docker-registry
- Enabling Kubernetes (kubelet) to pull the images from the private registry
