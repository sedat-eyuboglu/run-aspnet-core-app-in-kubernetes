# run-aspnet-core-app-in-kubernetes

The sample to run AspNet Core application in [Kubenetes](https://kubernetes.io/).

The sample uses a kubernetes cluster installed by Docker Desktop on the local machine.

The application is accessible from the host machine via a `NodePort` [Service](https://kubernetes.io/docs/concepts/services-networking/service/) definition. In a production, An [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) controller would be helpfull to serve your application to outside of the cluster. You should consider that a load balancer is also required to configure a appropriate environment. Those consepts are out of scope for this sample.  

For this sample an image registry also required. Kubernetes needs to pull application images from a image registry to create the container and place it in a [Pod](https://kubernetes.io/docs/concepts/workloads/pods/). Indeed, we could use docker's public hub to pull a sample AspNetCore image. We want to make you more familier with what a image registry is. So we create a sample "private image resitry" in the docker.

Stpes to run an AspNet Core app in kubernetes.

## Install Docker Desktop And Kubernetes on Docker

[https://birthday.play-with-docker.com/kubernetes-docker-desktop/](https://birthday.play-with-docker.com/kubernetes-docker-desktop/)

Open docker desktop dashboard and goo settings. Enter insecure resgistry like below. As a default behaviour kubernetes try to pull images from secure endpoints and uses https. Since we use a quick private registry, we don't have any https endpoint. Use your ipv4 address instead of *192.168.56.1*.

```json
{
  "registry-mirrors": [],
  "insecure-registries": [
    "192.168.56.1:5005"
  ],
  "debug": true,
  "experimental": false
}
```

## Create New AspNet Core App

```
git clone https://github.com/sedat-eyuboglu/run-aspnet-core-app-in-kubernetes.git
```

## Publish AspNet App

```
dotnet publish -c Release -o publish
```

## Build Docker Image

```
docker build -t sampleapp .
docker tag sampleapp localhost:5005/sampleapp
```

## Run a Private Container Registry Localy

```
docker run -d -p 5005:5000 --restart always --name registry registry:2
```

## Push Image to Local Repository

```
docker push localhost:5005/sampleapp
```

## Create Kubernetes Components

Create deployment and service components.

### Deployment

[deployment/deployment.yaml](deployment/deployment.yaml)

### Service

[deployment/service.yaml](deployment/service.yaml)

Service assigns a random port number to our service. To find out port number used, run following *kubectl* command and look for *sampleapp* service. You should see a port number greater than 30000 in the PORT(S) field. After geting port number, open your browser and go to *localhost:port*.

```
kubectl get service
```