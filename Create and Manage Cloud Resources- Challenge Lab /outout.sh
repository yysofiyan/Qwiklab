NAME: web-server-firewall
NETWORK: nucleus-vpc
DIRECTION: INGRESS
PRIORITY: 1000
ALLOW: tcp:80
DENY:
DISABLED: False
student_02_275b2bc361de@cloudshell:~ (qwiklabs-gcp-01-2a15c155d4fb)$ gcloud compute http-health-checks create http-basic-check
gcloud compute instance-groups managed \
 set-named-ports web-server-group \
 --named-ports http:80 \
 --region us-west3-b
Created [https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-01-2a15c155d4fb/global/httpHealthChecks/http-basic-check].
NAME: http-basic-check
HOST:
PORT: 80
REQUEST_PATH: /
ERROR: (gcloud.compute.instance-groups.managed.set-named-ports) Could not set named ports for resource:

- Invalid value for field 'region': 'us-west3-b'. Unknown region.

student_02_275b2bc361de@cloudshell:~ (qwiklabs-gcp-01-2a15c155d4fb)$ gcloud compute instance-groups managed create web-server-group \
 --base-instance-name web-server \
 --size 2 \
 --template web-server-template \
 --region us-west3
Created [https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-01-2a15c155d4fb/regions/us-west3/instanceGroupManagers/web-server-group].
NAME: web-server-group
LOCATION: us-west3
SCOPE: region
BASE_INSTANCE_NAME: web-server
SIZE: 0
TARGET_SIZE: 2
INSTANCE_TEMPLATE: web-server-template
AUTOSCALED: no
student_02_275b2bc361de@cloudshell:~ (qwiklabs-gcp-01-2a15c155d4fb)$ gcloud compute firewall-rules create web-server-firewall \
 --allow tcp:80 \
 --network nucleus-vpc
Creating firewall...failed.
ERROR: (gcloud.compute.firewall-rules.create) Could not fetch resource:

- The resource 'projects/qwiklabs-gcp-01-2a15c155d4fb/global/firewalls/web-server-firewall' already exists

student_02_275b2bc361de@cloudshell:~ (qwiklabs-gcp-01-2a15c155d4fb)$ gcloud compute firewall-rules create web-server-firewall --allow tcp:940 --network nucleus-vpc
Creating firewall...failed.
ERROR: (gcloud.compute.firewall-rules.create) Could not fetch resource:

- The resource 'projects/qwiklabs-gcp-01-2a15c155d4fb/global/firewalls/web-server-firewall' already exists

student_02_275b2bc361de@cloudshell:~ (qwiklabs-gcp-01-2a15c155d4fb)$ gcloud compute http-health-checks create http-basic-check
gcloud compute instance-groups managed \
 set-named-ports web-server-group \
 --named-ports http:80 \
 --region us-west3
ERROR: (gcloud.compute.http-health-checks.create) Could not fetch resource:

- The resource 'projects/qwiklabs-gcp-01-2a15c155d4fb/global/httpHealthChecks/http-basic-check' already exists

Updated [https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-01-2a15c155d4fb/regions/us-west3/instanceGroups/web-server-group].
student_02_275b2bc361de@cloudshell:~ (qwiklabs-gcp-01-2a15c155d4fb)$ gcloud compute backend-services create web-server-backend \
 --protocol HTTP \
 --http-health-checks http-basic-check \
 --global
Created [https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-01-2a15c155d4fb/global/backendServices/web-server-backend].
NAME: web-server-backend
BACKENDS:
PROTOCOL: HTTP
student_02_275b2bc361de@cloudshell:~ (qwiklabs-gcp-01-2a15c155d4fb)$ gcloud compute backend-services add-backend web-server-backend \
 --instance-group web-server-group \
 --instance-group-region us-east1 \
 --global
ERROR: (gcloud.compute.backend-services.add-backend) Could not fetch resource:

- The resource 'projects/qwiklabs-gcp-01-2a15c155d4fb/regions/us-east1/instanceGroups/web-server-group' was not found

student_02_275b2bc361de@cloudshell:~ (qwiklabs-gcp-01-2a15c155d4fb)$ gcloud compute backend-services add-backend web-server-backend \
 --instance-group web-server-group \
 --instance-group-region us-west3 \
 --global
Updated [https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-01-2a15c155d4fb/global/backendServices/web-server-backend].
student_02_275b2bc361de@cloudshell:~ (qwiklabs-gcp-01-2a15c155d4fb)$ gcloud compute url-maps create web-server-map \
 --default-service web-server-backend
Created [https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-01-2a15c155d4fb/global/urlMaps/web-server-map].
NAME: web-server-map
DEFAULT_SERVICE: backendServices/web-server-backend
student_02_275b2bc361de@cloudshell:~ (qwiklabs-gcp-01-2a15c155d4fb)$ gcloud compute target-http-proxies create http-lb-proxy \
 --url-map web-server-map
Created [https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-01-2a15c155d4fb/global/targetHttpProxies/http-lb-proxy].
NAME: http-lb-proxy
URL_MAP: web-server-map
student_02_275b2bc361de@cloudshell:~ (qwiklabs-gcp-01-2a15c155d4fb)$ gcloud compute forwarding-rules create http-content-rule \
 --global \
 --target-http-proxy http-lb-proxy \
 --ports 80
gcloud compute forwarding-rules list
Created [https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-01-2a15c155d4fb/global/forwardingRules/http-content-rule].
NAME: http-content-rule
REGION:
IP_ADDRESS: 35.244.213.114
IP_PROTOCOL: TCP
TARGET: http-lb-proxy

NAME: a2f12ab6e7d5b47939941815c848851d
REGION: us-west3
IP_ADDRESS: 34.106.164.135
IP_PROTOCOL: TCP
TARGET: us-west3/targetPools/a2f12ab6e7d5b47939941815c848851d

NAME: gke-nucleus-backend-b1258ea8-dc4d4d17-pe
REGION: us-west3
IP_ADDRESS: 10.180.0.3
IP_PROTOCOL:
TARGET: us-west3/serviceAttachments/gke-b1258ea8afe044feae26-5bc6-f34b-sa
student_02_275b2bc361de@cloudshell:~ (qwiklabs-gcp-01-2a15c155d4fb)$
