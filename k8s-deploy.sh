kubectl create deployment tomcat-sessions --image=control.demiflat.org:5000/tomcat-sessions:0 --port=8080 --replicas=3
kubectl create service clusterip nginx --tcp=80:8080
kubectl create service clusterip tomcat-sessions --tcp=80:8080
kubectl apply -f k8s-role.yaml
kubectl apply -f k8s-ingress.yaml

