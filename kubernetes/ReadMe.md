#Installation Guide for Kubernetes 1.9 using KubeAdmn

1. Make sure VXLan is supported by the OS
 to check you can run
 
 ```
 curl -sSL https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh | bash
 ```
 
2. If you are using Kubernetes 1.7+ then the following applies:
 * Swap must be disabled 
 * You can check if you have swap enabled by typing in cat /proc/swaps. If you have a swap file or partition enabled then turn it off with `swapoff -a`. You can make this permanent by commenting out the swap file in /etc/fstab.

3. Execute Installion Procedures of Docker, Kubernetes and Othre Tools
```
curl -sS https://raw.githubusercontent.com/albertoclarit/DevOps/master/settingk8.sh | bash
```

