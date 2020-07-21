Vagrant.configure(2) do |config|
  config.vm.define "web01" do |web01|
    web01.vm.box = "centos/7"
    web01.vm.network "private_network", ip: "192.168.111.101"
    web01.vm.hostname = "web01"
    web01.vm.provider "vmware_desktop" do |v|
      v.vmx["memsize"] = "512"
      v.vmx["numvcpus"] = "2"
    end
  end
  config.vm.define "web02" do |web02|
    web02.vm.box = "centos/7"
    web02.vm.network "private_network", ip: "192.168.111.102"
    web02.vm.hostname = "web02"
    web02.vm.provider "vmware_desktop" do |v|
      v.vmx["memsize"] = "512"
      v.vmx["numvcpus"] = "2"
    end
  end
  config.vm.define "lb01" do |lb01|
    lb01.vm.box = "centos/7"
    lb01.vm.network "private_network", ip: "192.168.111.111"
    lb01.vm.hostname = "lb01"
  end
  config.vm.define "tls01" do |tls01|
    tls01.vm.box = "centos/7"
    tls01.vm.network "private_network", ip: "192.168.111.112"
    tls01.vm.hostname = "tls01"
  end
  config.vm.define "tls02" do |tls02|
    tls02.vm.box = "centos/7"
    tls02.vm.network "private_network", ip: "192.168.111.113"
    tls02.vm.hostname = "tls02"
  end
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.host_vars = {
      "web01" => {"new_hostname" => "web01",
                  "ansible_ssh_host" => "192.168.111.101",
                  "ansible_ssh_port" => "22"},
      "web02" => {"new_hostname" => "web02",
                  "ansible_ssh_host" => "192.168.111.102",
                  "ansible_ssh_port" => "22"},
      "lb01" => {"new_hostname" => "lb01",
                  "ansible_ssh_host" => "192.168.111.111",
                  "ansible_ssh_port" => "22"},
      "tls01" => {"new_hostname" => "tls01",
                  "ansible_ssh_host" => "192.168.111.112",
                  "ansible_ssh_port" => "22"},
      "tls02" => {"new_hostname" => "tls02",
                  "ansible_ssh_host" => "192.168.111.113",
                  "ansible_ssh_port" => "22"}
    }
    ansible.groups = {
      "nginxplus-ws" => ["web0[1:2]"],
      "nginxplus-lb" => ["lb01"],
      "nginxplus-tls" => ["tls0[1:2]"],
      "nginxplus-ctl" => ["ctl01"]
    }
  end
end
