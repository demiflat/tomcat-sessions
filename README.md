# tomcat sessions                                                  

## This project shows how to configure a simple servlet to run on Tomcat in Kubernetes with distributed session replication.

### There are two tested configurations:
 - conf/server.kubernetes.xml
  
This is a basic cluster configuration that leverages the Tomcat cluster membership implementation that gets membership information from the Kubernetes API.


 - conf/server.kubernetes.async.xml

This is a configuation that distributes state using the Tomcat pooled parallel asynchronous sender.


#### Running make will list build targets

- DOCKER_REGISTRY 

Define environment variable $DOCKER_REGISTRY for the container registry used.