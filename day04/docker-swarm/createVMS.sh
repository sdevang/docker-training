docker-machine create mgr-1 -d google --google-machine-type n1-standard-1 --google-tags myswarm --google-project k8s-training-272213 --google-preemptible
docker-machine create mgr-2 -d google --google-machine-type n1-standard-1 --google-tags myswarm --google-project k8s-training-272213 --google-preemptible
docker-machine create mgr-3 -d google --google-machine-type n1-standard-1 --google-tags myswarm --google-project k8s-training-272213 --google-preemptible
docker-machine create w-1 -d google --google-machine-type n1-standard-1 --google-tags myswarm --google-project k8s-training-272213 --google-preemptible
docker-machine create w-2 -d google --google-machine-type n1-standard-1 --google-tags myswarm --google-project k8s-training-272213 --google-preemptible