# Installation Guide for Kubernetes 1.9 using KubeAdm

## The ff. Commands assumes you are running in root i.e. `sudo -i`
1. Make sure VXLan is supported by the OS
 to check you can run
 
 ```bash
 curl -sSL https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh | bash
 ```
 
2. If you are using Kubernetes 1.7+ then the following applies:
 * Swap must be disabled 
 * You can check if you have swap enabled by typing in cat /proc/swaps. If you have a swap file or partition enabled then turn it off with `swapoff -a`. You can make this permanent by commenting out the swap file in /etc/fstab.

3. Execute Installation Procedures of Docker, Kubernetes and Other Tools
```
curl -sS https://raw.githubusercontent.com/albertoclarit/RestKube/master/kubernetes/settingk8.sh | bash
```

4. Initialize Kubernetes Admin
```bash
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.1.149 --kubernetes-version stable-1.9 --ignore-preflight-errors=cri

```
Note that 192.168.1.149 is the IP of the master node. Also take note of the 
output from this command particulary the join commands for the worker nodes


5. kubectl commands should be done on non-root user 
```bash
adduser master
usermod -aG sudo master
 ```
6. Then login to that user
 ```bash
  su master
  curl -sS https://raw.githubusercontent.com/albertoclarit/RestKube/master/kubernetes/setupenv.sh | bash
 ```
 
7. By default, a master node are not scheduled for pod deployment. You can allow master to join by 
```bash
 kubectl taint nodes --all node-role.kubernetes.io/master-
```

8. Install a Pod Network/Cluster network based on CNI (Container Network Interface). In this example is Flannel.
[For more info ] (https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#pod-network)
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

9. At this point in time, Kubernetes is now ready to be joined. You can check the existing
cluster nodes at 
```
kubectl get nodes
```

To Let other nodes join, execute the commands  in root user from other nodes
```
kubeadm join --token d9c7f4.77c2d5a44526aab1 192.168.1.149:6443 --discovery-token-ca-cert-hash sha256:40f55e0c71cec177213f7e3dee397f4d916243346e716fb52dc1c6d36255574c  --ignore-preflight-errors=cri
```

10. Check if pods and services are ready.

```
kubectl get all -o wide --all-namespaces
```


# Installing a Test App

1. Install a Test Rest App 
```
curl https://raw.githubusercontent.com/albertoclarit/RestKube/master/kubernetes/testrestdeployment.yaml \
    | kubectl apply -f -
```

You can monitor the deployment of your pods in the cluster by opening another terminal
```
kubectl get pods,svc,ing -o wide --all-namespaces
```

You can test each pod by 
```
curl [clusterip]:4567
```

2. Expose All the apps for load balancing in the Cluster (using ClusterIP)
```
curl https://raw.githubusercontent.com/albertoclarit/RestKube/master/kubernetes/testrestservice.yaml \
       | kubectl apply -f -
```

3. Installing an Ingress Controller. Ingress-Nginx does not work on BareMetal Installation
Instead [traefik](https://docs.traefik.io/) works perfectly

```
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml
```

4. Traefik can be deployed as either a Deployment or a DaemonSet (it guarantees that one Pod of the DeamonSet is present in every node)
In our example we will deploy as a Daemonset

```
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-ds.yaml
```

5. Traefik can have a WebUI for management and tracking.
First lets install the Service

```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: traefik-web-ui
  namespace: kube-system
spec:
  selector:
    k8s-app: traefik-ingress-lb
  ports:
  - port: 80
    targetPort: 8080
EOF

```

7. Lets create an Ingress entry for this Web UI
```
cat <<EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: traefik-web-ui
  namespace: kube-system
  annotations:
    kubernetes.io/ingress.class: traefik
spec:
  rules:
  - host: webui.192.168.1.149.nip.io
    http:
      paths:
      - backend:
          serviceName: traefik-web-ui
          servicePort: 80
EOF
```


6. Install an Ingress to our Test Rest App

```
cat <<EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: trainingdomain
  annotations:
      kubernetes.io/ingress.class: traefik
spec:
  rules:
  - host: test.192.168.1.149.nip.io
    http:
      paths:
      - path: /
        backend:
          serviceName: albert-training-service
          servicePort: 80
EOF
```

7. You can now access our App Load-balanced with 10 pods at 
http://test.192.168.1.149.nip.io

8. Of course you should modify the IP Address :-P