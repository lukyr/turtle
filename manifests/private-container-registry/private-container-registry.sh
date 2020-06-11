#let's log into docker 
sudo docker login

#let's pull down a hello-world image from gcr
sudo docker pull gcr.io/google-samples/hello-app:1.0

#Let's get our image ID so we can tag it locally
sudo docker image ls gcr.io/google-samples/hello-app:1.0

#Tagging our image in the format your registry, image tag
#You'll be using your own repository, so update that information here
sudo docker tag bc5c421ecd6c datahubid/hello-app:ps

#Now push that locally tagged image into our private registry at docker hub
#You'll be using your own repository, so update that information here
sudo docker push datahubid/hello-app:ps

#we need to adjust permissions on our config.json file, since i did a sudo docker erlier
sudo chown $(id -u):$(id -g) ~/.docker/
sudo chown $(id -u):$(id -g) ~/.docker/config.json

#Create our secret that we'll use for our image pull.. from our docker config.json
#This is of the type generic, for docker-registry, look at line 48
kubectl create secret generic private-reg-cred \
    --from-file=.dockerconfigjson=/root/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson

#..or if needed we can specify this explicitly using the following parametes
kubectl create secret docker-registry private-reg-cred \
    --docker-server=https://index.docker.io/v1/ \
    --docker-username=$USERNAME \
    --docker-password=$PASSWORD \
    --docker-email=$EMAIL

#Ensure the image doesn't exist on any of our nodes..or else we can geta false positivve
#you'll be using your own repository, so update that information here
vagrant ssh kmaster 'sudo docker rmi datahubid/hello-app:ps'
vagrant ssh kworker1 'sudo docker rmi datahubid/hello-app:ps'
vagrant ssh kworker2 'sudo docker rmi datahubid/hello-app:ps'