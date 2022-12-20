# GSP313: Create and Manage Cloud Resources

## The challenge contains 3 required tasks

1. Creating a Project Jumphost instance.
2. Creating a Kubernetes Service Cluster.
3. Creating the Web Server Frontend.

⭐️ [My Badge](https://www.cloudskillsboost.google/public_profiles/9b6803b0-ccf7-4348-8eb5-31b63b46d461/badges/3050001)

*`Task 1. Create a project jumphost instance
`*

The first step is to create a Jumphost instance

```shell
gcloud compute instances create nucleus-jumphost-177 \
--network nucleus-vpc \
--zone us-west3-b  \
--machine-type f1-micro  \
--image-family debian-11  \
--image-project debian-cloud \
--scopes cloud-platform \
--no-address
```

`Task 2. Create a Kubernetes service cluster`

In this step, you have to create a Kubernetes Service Cluster

```shell
gcloud container clusters create nucleus-backend \
--num-nodes 1 \
--network nucleus-vpc \
--region us-west3-b
```

```shell
gcloud container clusters get-credentials nucleus-backend \
--region us-west3-b
```

```shell
kubectl create deployment hello-server \
--image=gcr.io/google-samples/hello-app:2.0
```

```shell
kubectl expose deployment hello-server \
--type=LoadBalancer \
--port 8082
```

`Task 3. Set up an HTTP load balancer
`

In this step, you have to create a serve the site via Nginx web servers

```shell
gcloud compute instance-templates create web-server-template \
--metadata-from-file startup-script=startup.sh \
--network nucleus-vpc \
--machine-type g1-small \
--region us-west3
```

```shell
gcloud compute instance-groups managed create web-server-group \
--base-instance-name web-server \
--size 2 \
--template web-server-template \
--region us-west3
```

```shell
gcloud compute firewall-rules create allow-tcp-rule-940 \
--allow tcp:80 \
--network nucleus-vpc
```

```shell
gcloud compute http-health-checks create http-basic-check

```
```shell
gcloud compute instance-groups managed \
set-named-ports web-server-group \
--named-ports http:80 \
--region us-west3
```

```shell
gcloud compute backend-services create web-server-backend \
--protocol HTTP \
--http-health-checks http-basic-check \
--global
```

```shell
gcloud compute backend-services add-backend web-server-backend \
--instance-group web-server-group \
--instance-group-region us-west3 \
--global
```

```shell
gcloud compute url-maps create web-server-map \
--default-service web-server-backend
```

```shell
gcloud compute target-http-proxies create http-lb-proxy \
--url-map web-server-map
```

```shell
gcloud compute forwarding-rules create http-content-rule \
--global \
--target-http-proxy http-lb-proxy \
--ports 80
```

```shell
gcloud compute forwarding-rules list
```

_Congratulations! Done with the challenge lab._

