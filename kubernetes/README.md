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

3. Execute Installion Procedures of Docker, Kubernetes and Other Tools
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

