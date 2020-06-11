# Let's create a namespace finance
kubectl create ns finance

# Use the utility “openssl” to generate the key and CSR. This utility comes with the OpenSSL package.
# Generate a Private key 2048 bit RSA Key using the following command:
openssl genrsa 2048 > temp/adam.key    

#Generate key CSR 
openssl req -new -key adam.key -out adam.csr -subj "/CN=adam/O=finance"

#ssh into kmaster
vagrant ssh kmaster

#copy ca.crt & ca.key from /etc/kubernetes/pki/ca.[crt,key]
scp root@kmaster:/etc/kubernetes/pki/ca.{crt,key} .

#Generate Certificate key
openssl x509 -req -in adam.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out adam.crt -days 365

#create new kubeconfig
kubectl --kubeconfig adam.kubeconfig config set-cluster kubernetes --server https://172.42.42.100:6443 --certificate-authority=ca.crt 

#view kubeconfig
kubectl config view

#set credential adam cubeconfig
kubectl --kubeconfig adam.kubeconfig config set-credential adam --client-certificate /path/to/temp/adam.crt --client-key /path/to/temp/adam.key

#set context
kubectl --kubeconfig adam.kubeconfig config set-context adam-kubernetes --cluster kubernetes --namespace finance --user finance

# rm adam.kubeconfig
rm -r adam.kubeconfig

# copy /kube/config
cp ~/.kube/config adam.kubeconfig

# copy adam.crt into client-certificate-data section
cat /temp/adam.crt | base64

# copy adam.key into client-key-data section
cat /temp/adam.key | base64

#create role
kubectl create role adam-finance --verb=get,list --resource=pods --namespace finance

#kind: Role
#apiVersion: rbac.authorization.k8s.io/v1
#metadata:
#  namespace: mynamespace
#  name: example-role-2
#rules:
#- apiGroups: ["extensions", "apps"]
#  resources: ["deployments"]
#  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

#check manifest of role adam-finance
kubectl -n finance get role adam-finance -o yaml

#create rolebinding adam-finance-rolebinding
kubectl create rolebinding adam-finance-rolebinding --role=adam-finance --user=adam --namespace finance

#check manifest of role adam-finance-rolebinding
kubectl -n finance get rolebinding adam-finance-rolebinding -o yaml

#Edit role adam-finance, change - apiGroups: '*'
kubectl edit role adam-finance -n finance

#Create other user.
#Generate a Private key 2048 bit RSA Key 
openssl genrsa -out haura.key 2048

#Generate Certificate Signing Request (CSR)
openssl req -new -key haura.key -out haura.csr -subj "/CN=haura/O=finance"

#Generate certificate
openssl x509 -req -in haura.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out haura.crt -days 365

#Create kubeconfig & set cluster 
kubectl --kubeconfig haura.kubeconfig config set-cluster kubernetes --server https://172.42.42.100:6443 --certificate-authority ca.crt

#Set credentials --client-certificate & --client-key
kubectl --kubeconfig haura.kubeconfig config set-credentials haura --client-certificate /path/to/haura.crt --client-key /path/to/haura.key

#Set context 
kubectl --kubeconfig haura.kubeconfig config set-context haura-kubernetes --cluster kubernetes --namespace finance --user haura

#Create finance rolebinding make subject group
kubectl create rolebinding finance-rolebinding --role=john-finance --group=finance --namespace finance