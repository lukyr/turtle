#ssh to nfs server
vagrant ssh kmaster

#More details available here https://help.ubuntu.com/lts/serverguide/network-file-system.html
#Install NFS Server and create the directory for our exports
yum install -y nfs-utils
systemctl enable rpcbind
systemctl enable nfs-server
systemctl start rpcbind
systemctl start nfs-server

# -p, --parents
#no error if existing, make parent directories as needed
mkdir /var/nfsshare
chmod -R 755 /var/nfsshare
chown vagrant:vagrant /var/nfsshare

# ref https://medium.com/faun/openshift-dynamic-nfs-persistent-volume-using-nfs-client-provisioner-fcbb8c9344e

#Configure our NFS Export in /etc/export for /var/nfsshare. Using no_root_squash and no_subtree_check to
#allow aplications to mount subdirectories of the export directly
sudo bash -c 'echo "/var/nfsshare *(rw,no_root_squash,no_subtree_check)" > /etc/exports'
cat /etc/exports
systemctl enable rpcbind
systemctl enable nfs-server
systemctl start rpcbind
systemctl start nfs-server
exit

#On each in your cluster  install nfs client.
sudo yum -y install nfs-utils
sudo mount -t nfs4 kmaster:/var/nfsshare /mnt/
mount | grep nfs
sudo unmount /mnt
exit

#Create a PV with the read/write many pod and retain as the reclaim policy
kubectl apply -f static-persistence-volume/nfs.pv.yaml

#Review the created resources, status, access Mode and Reclaim policy is set to Reclaim rather than delete.
kubectl get PersistenceVolume pv-nfs-data

#Look more closely at the PV and it's configuration 
kubectl describe PersistenceVolume pv-nfs-data

#Check the status , Bound
#We defined the PVC it statically provisioned the PV..but it's not mounted yet.
kubectl get PersistenceVolumeClaim pvc-nfs-data
kubectl describe PersistenceVolumeClaim pvc-nfs-data

#Create some content on our nfs-server or storage server
sudo bash -c 'echo "Hello from our NFS mount!!!" > /var/nfsshare/demo.html'
more /export/volumes/pod/demo.html
exit

#Let's create a Pod (in a Deployment and add a service) with a PVC on pvc-nfs-data
kubectl apply -f static-persistence-volume/nfs.nginx.yaml
kubectl get service nginx-nfs-service
SERVICEIP=$(kubectl get service | grep nginx-nfs-service | awk '{ print $3 }')

#Let's access that application to see our application data...
curl http://$SERVICEIP/web-app/demo.html

#Check the Mounted By PersistentVolumeClaim pvc-nfs-data
kubectl describe PersistenceVolumeClaim pvc-nfs-data

#Check path inside the pod/container, let's look at where the PV is mounted
kubectl exec -it nginx-nfs-deployment-xxx -- /bin/bash
ls /usr/share/nginx/html/web-app
more /usr/share/nginx/html/web-app/demo.html
exit

#Let's log into that node and look at the mounted volumes..it's the kubeletes job to make the device/mount available
vagrant ssh kworkerx
mount | grep nfs
exit


#Replicate - Controlling PV access with access modes and PersistentVolumeReclaimPolicy
#Scale up the deployment to 4 replicas
kubectl scale deployment nginx-nfs-deployment --replicas=4


#Now lets look at who's attached to pvc , all 4 pods
#Our AccessMode for this PV and PVC is RWX ReadWriteMany
kubectl describe PersistenceVolumeClaim pvc-nfs-data



