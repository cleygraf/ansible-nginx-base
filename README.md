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

All the details of the infrastructure are stored in `inventory.yml`.

Ansible will use the ip in *ansible_ssh_host* to connect to the target server. The hostname will be changed to "new_hostname". sudo will be used to become root. If sudo needs a password, please encrypt and stored in `ansible_become_password`.

#### Ensure Ansible server has valid NGINX Plus license key and cert

To install NGINX Plus the NGINX Plus repositories are used. To access these repositories 
you have to provide a `nginx-repo.cert` and `nginx-repo.key` file. These files are expected to be find in
`~/nginx/certs/`. 

This can be configured in `./group_vars/all.yml`. Just look for `nginxplus_cert_key_path`. Please also check the 
other paths that can be configured in this file, e. g. for ssl certificates, the NGINX Controller license file ...

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

- JWT validation
see https://jwt.io

Header:
```
{
  "alg": "HS256",
  "typ": "JWT"
}
``` 

Payload:
```
{
  "fullName": "Christoph Leygraf",
  "url": "http://www.lab.leyux.org"
}
```

Signature:
```
nginx123
```

JWT:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmdWxsTmFtZSI6IkNocmlzdG9waCBMZXlncmFmIiwidXJsIjoiaHR0cDovL3d3dy5sYWIubGV5dXgub3JnIn0.PkD5pmaCmuKNMeqq_X2Q38Q0cZoAuTEecC-VXk9nNJg
``` 

```
curl "https:/www.lab.leyux.org/v1/greet?myjwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmdWxsTmFtZSI6IkNocmlzdG9waCBMZXlncmFmIiwidXJsIjoiaHR0cDovL3d3dy5sYWIubGV5dXgub3JnIn0.PkD5pmaCmuKNMeqq_X2Q38Q0cZoAuTEecC-VXk9nNJg" --insecure -H "Authorization: Bearer 
```

OpenID Connect Discovery:

```
https://dev-173872.okta.com/.well-known/openid-configuration
```

JWKS:

```
https://dev-173872.okta.com/oauth2/v1/keys
```

