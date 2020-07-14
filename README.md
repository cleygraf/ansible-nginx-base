# Ansible / NGINX Plus Demo

This is a demonstration on how to deploy and configure NGINX Plus as a load
balancer, a webserver and to terminate tls on CentOS7 using Ansible.
It's based on kmjones1979's work. I have updated it if necessary and added the tls termination part.

Tested using...

```
[cleygraf@tls01 ~]$ cat /etc/redhat-release
CentOS Linux release 7.8.2003 (Core)
[cleygraf@tls01 ~]$
```

#### Checkout ansible-demo

```
git clone git@github.com:cleygraf/ansible-demo.git
```

#### Prerequesits

Setup ssh login with keys for all servers. You might use ssh-add to add your private key to the ssh agent.


#### Configure Ansible inventory

I prefer to include as much as possible in the git repository. So I have added an inventory.yml file to hold all the details about the servers:

```
...
nginxplus-tls:
  hosts:
    tls01:
      new_hostname: tls01.home.local
      ansible_ssh_host: 192.168.1.112
    tls02:
      new_hostname: tls02.home.local
      ansible_ssh_host: 192.168.1.113
  vars:
    ansible_become: yes
    ansible_become_user: root
    ansible_become_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          31323961353662633632306166663033643436313135366430666434313862656666393536323265
          6635316339353537313736643163613439666134623733350a383461393638643762626630383232
          62626435656239336135666562373961346664326239653166653866663639303461636238346662
          6165366364663034650a323966373830316237646330386263613165663034656364653737363466
          3632
    nginxplus_cert_key_path: ~/nginx/certs/
    server_cert_key_path: ~/nginx/ssl/
...
```

Ansible will use the ip in *ansible_ssh_host* to connect to the target server. The hostname will be changed to "new_hostname". sudo will be used to become roor. If sudo needs a password, please encrypt and stored in ansible_become_password.

#### Ensure Ansible server has valid NGINX Plus license key and cert

In order to install NGINX Plus using this playbook from the Ansible server
you need to copy both your nginx-repo cert and key to your /etc/ssl/nginx directory.

The /etc/ssl/nginx directory on your Ansible server should contain both files like so...

```
[kjones@zion-development ~]# ls -l /etc/ssl/nginx/
total 12
-rwx------ 1 root root 1334 Sep  2 21:59 nginx-repo.crt
-rwx------ 1 root root 1704 Sep  2 21:59 nginx-repo.key
```

#### Setup authorization over SSH

From your ansible server generate an ssh-key for your root account...

```
su -c 'ssh-keygen'
sudo cat /root/.ssh/id_rsa.pub
```

...and copy the ssh key to your destination servers 'authorized_keys' file
that you defined in the ansible hosts file.

```
sudo vim /root/.ssh/authorized_keys
```

Note: You might need to create the ssh directory by running 'ssh-keygen' as root
on the destination servers.

#### Deploy

Deploy NGINX Plus Load Balancer

```
ansible-playbook ansible-nginxplus-lb/deploy.yml
```

Deploy NGINX Plus Web Servers

```
ansible-playbook ansible-nginxplus-lb/deploy.yml
```

#### Tips

 - Additional firewall configuration might be required on your servers.

To disable and stop your firewall on CentOS 7.1:

```
sudo systemctl disable firewalld
sudo systemctl stop firewalld
```

 - Running the nginxplus-ws playbook twice will result in duplicate upstreams.

Upstreams can be managed via the NGINX Plus API on the fly:
Visit http://nginx.org/en/docs/http/ngx_http_upstream_conf_module.html for more
information.

List upsteam servers for backend by id# :

```
curl 'http://127.0.0.1/upstream_conf?upstream=backend'
```

Remove a specific upstream by id# :
```
curl '127.0.0.1/upstream_conf?remove=&upstream=backend&id=0'
```

