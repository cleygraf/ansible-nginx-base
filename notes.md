
### Deploy web server
`ansible-playbook ./base.yml -l nginxplus-ws -i ./inventory.yml --ask-vault-pass`

`ansible-playbook ./ansible-nginxplus-ws/deploy.yml -l nginxplus-ws -i ./inventory.yml --ask-vault-pass`


### Deploy load balancer
`ansible-playbook ./base.yml -l nginxplus-lb -i ./inventory.yml --ask-vault-pass`

`ansible-playbook ./ansible-nginxplus-lb/deploy.yml -l nginxplus-lb -i ./inventory.yml --ask-vault-pass`

### Deploy ssl termination server (tls01&tls02)
`ansible-playbook ./base.yml -l nginxplus-tls -i ./inventory.yml --ask-vault-pass`

`ansible nginxplus-tls -i ./inventory.yml -m shell -a "/sbin/shutdown -r now" --ask-vault-pass`

`ansible-playbook ./ansible-nginxplus-tls/deploy.yml -l nginxplus-tls -i ./inventory.yml --ask-vault-pass`

## certbot / letsencrypt

Required package on WSL/Ubuntu: certbot python3-certbot-nginx
(running as non-privileged user is failing :-( )

`sudo certbot --manual certonly --config-dir ~/letsencrypt/ --work-dir ~/letsencrypt/ --logs-dir ~/letsencrypt/ --preferred-challenges dns`

