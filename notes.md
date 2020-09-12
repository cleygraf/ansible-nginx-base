
### Deploy web server
`ansible-playbook ./base.yml -l nginxplus-ws -i ./inventory.yml --ask-vault-pass`

`ansible nginxplus-ws -i ./inventory.yml -m reboot -b`

`ansible-playbook ./ansible-nginxplus-ws/deploy.yml -l nginxplus-ws -i ./inventory.yml --ask-vault-pass`

### Deploy load balancer
`ansible-playbook ./base.yml -l nginxplus-lb -i ./inventory.yml --ask-vault-pass`

`ansible nginxplus-lb -i ./inventory.yml -m reboot -b`

`ansible-playbook ./ansible-nginxplus-lb/deploy.yml -l nginxplus-lb -i ./inventory.yml --ask-vault-pass`

### Deploy ssl termination server (tls01&tls02)
`ansible-playbook ./base.yml -l nginxplus-tls -i ./inventory.yml --ask-vault-pass`

`ansible nginxplus-tls -i ./inventory.yml -m reboot -b`

`ansible-playbook ./ansible-nginxplus-tls/deploy.yml -l nginxplus-tls -i ./inventory.yml --ask-vault-pass`

## certbot / letsencrypt

Required package on WSL/Ubuntu: certbot python3-certbot-nginx
(running as non-privileged user is failing :-( )

`sudo certbot --manual certonly --config-dir ~/letsencrypt/ --work-dir ~/letsencrypt/ --logs-dir ~/letsencrypt/ --preferred-challenges dns`

## NGINX+ API

### Get upstream servers
`curl 'http://lb01:8080/api/3/http/upstreams/backend/servers/'`

### Remove upstream server
`curl -X DELETE 'http://lb01:8080/api/3/http/upstreams/backend/servers/0'`

### Add upstream server
` curl -X POST -d '{"server":"192.168.1.101:80"}' 'http://lb01:8080/api/3/http/upstreams/backend/servers'`

## PowerCLI

`foreach($vm in "ws01", "ws02", "lb01", "tls01", "tls02", "ctl01", "api01"){Get-VM $vm}`

`foreach($vm in "ws01", "ws02", "lb01", "tls01", "tls02", "ctl01", "api01"){Start-VM -VM $vm -Confirm:$false}`

`foreach($vm in "ws01", "ws02", "lb01", "tls01", "tls02", "ctl01", "api01"){Get-Snapshot -VM $vm | where {$_.IsCurrent -eq $true}}`

`foreach($vm in "ws01", "ws02", "lb01", "tls01", "tls02", "ctl01", "api01"){$snap=Get-Snapshot -VM $vm | where {$_.IsCurrent -eq $true};Set-VM -VM $vm -SnapShot $snap -Confirm:$false}`

## /etc/hosts on localhost
`ansible-playbook --connection=local ./tools/hosts.yml`