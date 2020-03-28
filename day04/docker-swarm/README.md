# Docker Swarm Setup on GCP

- Create GCE VMs for Docker Swarm cluster

  ```bash
  docker-machine create mgr-1 -d google --google-machine-type n1-standard-1 --google-tags myswarm --google-project k8s-training-272213 --google-preemptible
  docker-machine create mgr-2 -d google --google-machine-type n1-standard-1 --google-tags myswarm --google-project k8s-training-272213 --google-preemptible
  docker-machine create mgr-3 -d google --google-machine-type n1-standard-1 --google-tags myswarm --google-project k8s-training-272213 --google-preemptible
  docker-machine create w-1 -d google --google-machine-type n1-standard-1 --google-tags myswarm --google-project k8s-training-272213 --google-preemptible
  docker-machine create w-2 -d google --google-machine-type n1-standard-1 --google-tags myswarm --google-project k8s-training-272213 --google-preemptible
  docker-machine create portainer-vm -d google --google-machine-type n1-standard-1 --google-tags myswarm --google-project k8s-training-272213 --google-preemptible
  ```

* Check VMs spun up by docker-machine,

  ```bash
  docker-machine ls
  gcloud compute instances list
  ```

* Set the environment variables pointing to docker daemon running mgr-1 machine,

  ```bash
  eval "\$(docker-machine env mgr-1)"
  ```

* SSH into mgr-1 VM and initialize docker swarm

  ```bash
  docker-machine ssh mgr-1
  sudo docker swarm init --advertise-addr $(hostname -I | awk '{print $1}')
  sudo docker node ls
  ```

* Generate a swarm token for Manager nodes,

  ```bash
  sudo docker swarm join-token manager

  To add a manager to this swarm, run the following command:

  sudo docker swarm join --token SWMTKN-1-0bn4adscd5qdfofywj7fae70xgowm1jgl2cppzhb8rtmgordsh-dy65eh7a4jkahagjkf5ua5l1t 10.128.0.20:2377
  ```

* Generate a swarm token for Worker nodes,

  ```bash
  sudo docker swarm join-token worker
  sudo docker node ls

  To add a worker to this swarm, run the following command:

  sudo docker swarm join --token SWMTKN-1-0bn4adscd5qdfofywj7fae70xgowm1jgl2cppzhb8rtmgordsh-4fqn9vxkpgid07m6hqs1jm4z1 10.128.0.20:2377
  ```

* Configure Manager and Worker nodes,

  Join mgr-2,mgr-3 into cluster as manager nodes
  Join w-1,w-2 into cluster as worker nodes

* Create the Overlay Network for swarm cluster

  from mgr-1,

  ```bash
  sudo docker network list
  sudo docker network create --driver overlay nw1
  sudo docker network list
  ```

* Create Nginx Service in swarm cluster

  from mgr-1,

  ```bash
  sudo docker service create --replicas 6 --network nw1 -p 80:80/tcp --name nginx nginx
  sudo docker service ls
  sudo docker service ps nginx
  ```

* Check Internal Connectivity

  Get the private IP address of couple of nodes and try to curl on those IP Addresses.

  ```bash
  gcloud compute instances list --zone us-central1-a
  curl <Private IP>
  ```

* Check External Connectivity

  Before you can hit the nginx from outside, you need to create the firewall rule which allow access to port from outside world.

  ```bash
  gcloud compute firewall-rules create my-swarm-rule --allow tcp:80 --description "nginx service" --target-tags myswarm
  curl <external IP>
  ```

* Create a Load Balancer in Google Cloud Console and try to reach the Load Balancer IP from outside.

* Portainer Setup

  SSH into portainer-vm,

  ```bash
  sudo docker volume create portainer_data
  sudo docker run -d -p 9000:9000 -p 8000:8000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
  ```

  After that deploy portainer agent on one of the Manager node,

  ```bash
  curl -L https://downloads.portainer.io/agent-stack.yml -o agent-stack.yml && sudo docker stack deploy --compose-file=agent-stack.yml portainer-agent
  ```

  Access portainer UI from portainer-vm's external ip:9000

* Inspect Network

  ```bash
  sudo docker network inspect
  ```

* Inspect Nginx Service

  ```bash
  sudo docker service inspect nginx
  ```

* Bring the leader down

  ```bash
  sudo docker node ls
  gcloud compute instances stop mgr-1 --zone us-central1-a
  sudo docker node ls
  sudo docker service ps nginx
  gcloud compute instances start mgr-1 --zone us-central1-a
  sudo docker node ls
  ```

* Bring the Worker down

  ```bash
  sudo docker node ls
  gcloud compute instances stop w-1 --zone us-central1-a
  sudo docker node ls
  ```

* CleanUp

  ```bash
  gcloud compute instances delete mgr-1 mgr-2 mgr-3 w-1 w-2 portainer-vm --zone us-central1-a
  docker-machine rm mgr-1 mgr-2 mgr-3 w-1 w-2 portainer-vm
  ```
