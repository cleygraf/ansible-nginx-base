#!/bin/bash

KUBE_VERSION=1.15.5
containerd_version=1.2.10
docker_version=18.09

packages=(
  "kubeadm-${KUBE_VERSION}-0.x86_64"
  "kubelet-${KUBE_VERSION}-0.x86_64"
  "kubectl-${KUBE_VERSION}-0.x86_64"
  "containerd.io-${containerd_version}"
  "docker-ce-cli-${docker_version}.*"
  "docker-ce-${docker_version}.*"
  "jq"
  "yum-plugin-versionlock"
  "socat"
  "conntrack-tools"
)

# EPEL repository
yum install epel-release

# Google's k8s repository
tee -a /etc/yum.repos.d/kubernetes.repo <<EOF 1>/dev/null
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Docker CE repository
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install -y -q yum-utils 2>/dev/null

echo ""
echo "Fetch the following files:"
yumdownloader -y -q --resolve --urls "${packages[@]}" 2>/dev/null

echo ""
echo "Install packages:"
echo "rpm -i *.rpm"

