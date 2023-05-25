kubectl create deployment tomcat --image=control.demiflat.org:5000/tomcat-sessions:0 --port=8080 --replicas=3
#kubectl create service clusterip nginx --tcp=80:8080
#kubectl create service clusterip tomcat --tcp=80:8080
kubectl create service clusterip tomcat --clusterip=None
kubectl apply -f k8s-role.yaml
kubectl apply -f k8s-ingress.yaml

