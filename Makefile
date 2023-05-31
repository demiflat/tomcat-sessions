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

REGISTRY:=$(DOCKER_REGISTRY)
CONTAINER_NAME=tomcat-sessions
CONTAINER_VERSION=10
CONTAINER_TAG="$(REGISTRY)/$(CONTAINER_NAME):$(CONTAINER_VERSION)"
DEPLOYMENT=tomcat-sessions
DEPLOYMENT_PORT=8080
NAMESPACE=default

info:
> @cat .info

all: login deploy kube-info kube-info-all

clean:
> rm -rf build

build:
> ./gradlew war

login:
> podman login $(REGISTRY)

docker: build
> podman build -f Containerfile -t $(CONTAINER_TAG)

push: docker
> podman push $(CONTAINER_TAG)

deploy: login push
> cat k8s/k8s-deployment.yaml | CONTAINER_TAG=$(CONTAINER_TAG) DEPLOYMENT=$(DEPLOYMENT) DEPLOYMENT_PORT=$(DEPLOYMENT_PORT) envsubst | kubectl apply -f -
> kubectl create service clusterip $(DEPLOYMENT) --tcp=8080:8080
> cat k8s/k8s-ingress.yaml | DEPLOYMENT=$(DEPLOYMENT) DEPLOYMENT_PORT=$(DEPLOYMENT_PORT) envsubst | kubectl apply -f -
> cat k8s/k8s-role.yaml | NAMESPACE=$(NAMESPACE) envsubst | kubectl apply -f -
> kubectl get all

destroy:
> kubectl delete deployment $(DEPLOYMENT) --ignore-not-found=true
> kubectl delete service $(DEPLOYMENT) --ignore-not-found=true
> kubectl delete ingress $(DEPLOYMENT) --ignore-not-found=true
> kubectl get all

kube-info:
> kubectl get all

kube-info-all:
> kubectl get -A all

watch:
> watch -n 2 $(MAKE) kube-info