# Creating and exploring an nginx deployment and Deploy it into our cluster.

#run file deployment.yaml reccomended by K8s.
 kubectl apply -f https://k8s.io/examples/application/deployment.yaml

#Display information about the Deployment:
kubectl describe deployment nginx-deployment

#List the Pods created by the deployment:
kubectl get pods -l app=nginx

#Display information about a Pod:
kubectl describe pod <pod-name> #replace <pod name> by the name that listed on the above command.

#=>> now we successfully deploy an K8s cluster on AWS by using KOps. Our cluster could work as Iaas for other services.