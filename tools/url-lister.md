# url-lister.sh

This script lists the urls of the missing packages (incl. dependecies) required to run NGINX controller on CENTOS. It is ment to be used together with the offline installer file for NGINX controller. The urls can be used to download the packages on another machine, transfer them to a target server and install them there.

A part of the packages (jq, kubernetes-cni, cri-tools, kubelet, kubectl, kubeadm) are already part of the offline installer archive (path: controller-installer/files/packages/rpm/). 

Please keep in mind, that this script adds the EPEL, Google Kubernetes and Docker CE repository to the system. In addition, the package `yum-utils` will be installed by the script.

## Usage

To only get the list of urls, please use grep to filter:

```url-lister.sh | grep "^http" > rpms_to_add.txt```

To download the packages, you can use curl:

```for i in $(cat ./rpms_to_add.txt); do curl -O $i ; done```

Packages can be installer with rpm:

```rpm -ivh ./*.rpm```

Here are the necessary additional steps before running install.sh:

```
systemctl enable docker.service
systemctl start docker.service
swapoff -a
tar -xzf ./offline-controller-installer-2046859.tar.gz
cd controller-installer/
cp ./files/cluster/docker-daemon.json /etc/docker/daemon.json
systemctl restart docker.service
```

As kubernetes requires swap to be disabled, please comment the appropiate lines in `/etc/fstab`.