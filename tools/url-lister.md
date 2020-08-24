# url-lister.sh

This script lists the urls of the missing packages (incl. dependecies) required to run NGINX controller on CENTOS. It is ment to be used together with the offline installer file for NGINX controller. The urls can be used to download the packages on another machine, transfer them to a target server and install them there.

A part of the packages (jq, kubernetes-cni, cri-tools, kubelet, kubectl, kubeadm) are already part of the offline installer archive (path: controller-installer/files/packages/rpm/). 

Please keep in mind, that this script adds the EPEL, Google Kubernetes and Docker CE repository to the system. In addition, the package `yum-utils` will be installed by the script. 

## Usage

`url-lister.sh` needs to run as _root_ because repositories are added and packages get installed.

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

## Sample output of an update CENTOS 7 system (minimal install)

```
# ./url-lister.sh
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.rrzn.uni-hannover.de
 * epel: ftp.fau.de
 * extras: ftp.halifax.rwth-aachen.de
 * updates: ftp.halifax.rwth-aachen.de
Package epel-release-7-12.noarch already installed and latest version
Nothing to do
Loaded plugins: fastestmirror
adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
repo saved to /etc/yum.repos.d/docker-ce.repo
Package yum-utils-1.1.31-54.el7_8.noarch already installed and latest version

Fetch the following files:
https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/Packages/a1ae562a4bcac2ccc85a4a7947cd062ecab691011ec59657bc705318e7477143-kubeadm-1.15.5-0.x86_64.rpm
https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/Packages/4e3e9edc797eed91c0d5ab63b3dd464e82d877e355cae5f35e8f31c9e203658a-kubelet-1.15.5-0.x86_64.rpm
https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/Packages/90dbd280f7fa38882e359cb83ca415f8d3596d9e4ff3e8e8fc11013042a0c192-kubectl-1.15.5-0.x86_64.rpm
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.10-3.2.el7.x86_64.rpm
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-18.09.9-3.el7.x86_64.rpm
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-18.09.0-3.el7.x86_64.rpm
https://mirror.23media.com/epel/7/x86_64/Packages/j/jq-1.6-2.el7.x86_64.rpm
http://ftp.halifax.rwth-aachen.de/centos/7.8.2003/updates/x86_64/Packages/yum-plugin-versionlock-1.1.31-54.el7_8.noarch.rpm
http://ftp.rrzn.uni-hannover.de/centos/7.8.2003/os/x86_64/Packages/socat-1.7.3.2-2.el7.x86_64.rpm
http://ftp.rrzn.uni-hannover.de/centos/7.8.2003/os/x86_64/Packages/conntrack-tools-1.4.4-7.el7.x86_64.rpm
http://ftp.rrzn.uni-hannover.de/centos/7.8.2003/os/x86_64/Packages/libnetfilter_queue-1.0.2-2.el7_2.x86_64.rpm
http://ftp.halifax.rwth-aachen.de/centos/7.8.2003/extras/x86_64/Packages/container-selinux-2.119.2-1.911c772.el7_8.noarch.rpm
https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/Packages/14bfe6e75a9efc8eca3f638eb22c7e2ce759c67f95b43b16fae4ebabde1549f3-cri-tools-1.13.0-0.x86_64.rpm
https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/Packages/029bc0d7b2112098bdfa3f4621f2ce325d7a2c336f98fa80395a3a112ab2a713-kubernetes-cni-0.8.6-0.x86_64.rpm
http://ftp.rrzn.uni-hannover.de/centos/7.8.2003/os/x86_64/Packages/libnetfilter_cthelper-1.0.0-11.el7.x86_64.rpm
http://ftp.rrzn.uni-hannover.de/centos/7.8.2003/os/x86_64/Packages/checkpolicy-2.5-8.el7.x86_64.rpm
http://ftp.rrzn.uni-hannover.de/centos/7.8.2003/os/x86_64/Packages/python-IPy-0.75-6.el7.noarch.rpm
http://ftp.rrzn.uni-hannover.de/centos/7.8.2003/os/x86_64/Packages/policycoreutils-python-2.5-34.el7.x86_64.rpm
http://ftp.rrzn.uni-hannover.de/centos/7.8.2003/os/x86_64/Packages/libnetfilter_cttimeout-1.0.0-7.el7.x86_64.rpm
http://ftp.rrzn.uni-hannover.de/centos/7.8.2003/os/x86_64/Packages/setools-libs-3.3.8-4.el7.x86_64.rpm
http://ftp.rrzn.uni-hannover.de/centos/7.8.2003/os/x86_64/Packages/libsemanage-python-2.5-14.el7.x86_64.rpm
http://ftp.rrzn.uni-hannover.de/centos/7.8.2003/os/x86_64/Packages/audit-libs-python-2.8.5-4.el7.x86_64.rpm
https://mirror.23media.com/epel/7/x86_64/Packages/o/oniguruma-6.8.2-1.el7.x86_64.rpm
http://ftp.rrzn.uni-hannover.de/centos/7.8.2003/os/x86_64/Packages/libcgroup-0.41-21.el7.x86_64.rpm

Install packages:
rpm -i *.rpm
#
```