#Creating and accessing Secrets
#Generic - Create a secret from a local file, directory or literal value
#They Keys and values are case sensiitive
kubectl create secret generic app1 \
 --from-literal=USERNAME=app1login \
 --from-literal=PASSWORD='S0methingS@Str0ng!'
#look help command
#kubectl create secret generic --help | less


 #Opaque means it's an arbitary user defined key/value pair. Data means two key/value pairs in the secret.
 #Other types include service accounts and container registry authentication info
 kubectl get secrets

 #app1 said it had 2 Data elements, lets look
 kubectl describe secret app1

 #If we need to access those at the command line
 #These are wrapped in bash expansion to add newline to output for readablility
 echo $(kubectl get secret app1 --template={{.data.USERNAME}})
 echo $(kubectl get secret app1 --template={{.data.USERNAME}} | base64 --decode)

 echo $(kubectl get secret app1 --template={{.data.PASSWORD}})
 echo $(kubectl get secret app1 --template={{.data.PASSWORD}} | base64 --decode)

#Deploy example pod
#Accessing Secrets inside a Pod
#As enironment variables
kubectl apply -f deployments/deployment-secrets-env.yaml

PODNAME=$(kubectl get pods | grep hello-world-secrets-env | awk '{print $1}' | head -n 1)
echo $PODNAME

#Now let's get our environment variables from our container
#Our Environment variables from our Pod spec are defined
#Notice the alpha information is there 
kubectl exec -it $PODNAME -- /bin/sh -c 'printenv | grep ^app1'

#Accessing Secrets as files
kubectl apply -f deployments/deployment-secrets-file.yaml

#Greb our Pod name into a variable
PODNAME=$(kubectl get pods | grep hello-world-secrets-file | awk '{print $1}' | head -n 1)
echo $PODNAME

#Looking more closely at the Pod we see volumes, appconfig in mounts..
kubectl describe pod $PODNAME

#lets access a shell on the pod
kubectl exec -it $PODNAME -- /bin/sh -c 'ls /etc/appconfig && \
cat /etc/appconfig/USERNAME && \
cat /etc/appconfig/PASSWORD'

#Additional examples of using secrets in your pods
#Create a secret using clear text and the stringData field
kubectl apply -f secret.string.yaml 

#Create a secret with encoded values, preffered over clear text.
echo -n 'app2login' | base64
echo -n 'S0methingsS@Strong!' | base64


