SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

REGISTRY=control.demiflat.org:5000
CONTAINER_NAME=tomcat-sessions
CONTAINER_VERSION=001
CONTAINER_TAG="$(REGISTRY)/$(CONTAINER_NAME):$(CONTAINER_VERSION)"
DEPLOYMENT=tomcat-sessions
NAMESPACE=default

gradle:
> ./gradlew war

login:
> podman login $(REGISTRY)

docker: gradle
> podman build -f Containerfile -t $(CONTAINER_TAG)

push: login docker
> podman push $(CONTAINER_TAG)

deploy: push
> kubectl create deployment $(DEPLOYMENT)  --image=$(CONTAINER_TAG) --port=8080 --replicas=3
> kubectl create service clusterip $(DEPLOYMENT) --clusterip=None
> cat k8s-ingress.yaml | DEPLOYMENT=$(DEPLOYMENT) envsubst | kubectl apply -f -
> cat k8s-role.yaml | NAMESPACE=$(NAMESPACE) envsubst | kubectl apply -f -

destroy:
> kubectl delete deployment $(DEPLOYMENT) --ignore-not-found=true
> kubectl delete service $(DEPLOYMENT) --ignore-not-found=true
> kubectl delete ingress $(DEPLOYMENT) --ignore-not-found=true
> kubectl get all

info:
> kubectl get all

all:
> kubectl get -A all
