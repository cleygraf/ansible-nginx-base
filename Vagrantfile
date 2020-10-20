Vagrant.configure(2) do |config|
  config.vm.define "n01" do |n01|
    n01.vm.box = "centos/7"
    n01.vm.network "private_network", ip: "192.168.111.111"
    n01.vm.hostname = "n01"
    n01.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]   
    end
    n01.vm.provider "vmware_desktop" do |v|
      v.vmx["memsize"] = "512"
      v.vmx["numvcpus"] = "2"
    end
  end
  config.vm.define "ctl" do |ctl|
    ctl.vm.box = "centos/7"
    ctl.vm.network "private_network", ip: "192.168.111.110"
    ctl.vm.hostname = "ctl"
    ctl.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "8192"]
      vb.customize ["modifyvm", :id, "--cpus", "8"]   
    end
    ctl.vm.provider "vmware_desktop" do |v|
      v.vmx["memsize"] = "8192"
      v.vmx["numvcpus"] = "8"
    end
  end
  config.vm.define "api" do |api|
    api.vm.box = "centos/7"
    api.vm.network "private_network", ip: "192.168.111.119"
    api.vm.hostname = "api"
    api.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]   
    end
    api.vm.provider "vmware_desktop" do |v|
      v.vmx["memsize"] = "1024"
      v.vmx["numvcpus"] = "2"
    end
  end
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "common.yml"
    ansible.host_vars = {
      "ctl" => {"new_hostname" => "ctl",
                  "ansible_ssh_host" => "192.168.111.110",
                  "ansible_ssh_port" => "22"},
      "n01" => {"new_hostname" => "n01",
                  "ansible_ssh_host" => "192.168.111.111",
                  "ansible_ssh_port" => "22"},
      "api" => {"new_hostname" => "api",
                  "ansible_ssh_host" => "192.168.111.119",
                  "ansible_ssh_port" => "22"}
    }
    ansible.groups = {
      "lb" => ["n01"],
      "api" => ["api"],
      "ctl" => ["ctl"]
    }
    ansible.extra_vars = {
      subdomain: "lab.local"
    }
  end
end
