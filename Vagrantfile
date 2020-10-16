Vagrant.configure(2) do |config|
  config.vm.define "n01" do |n01|
    n01.vm.box = "centos/7"
    n01.vm.network "private_network", ip: "192.168.111.111"
    n01.vm.hostname = "n01"
  end
  config.vm.define "ctl" do |ctl|
    ctl.vm.box = "centos/7"
    ctl.vm.network "private_network", ip: "192.168.111.112"
    ctl.vm.hostname = "ctl"
  end
  config.vm.define "api" do |api|
    api.vm.box = "centos/7"
    api.vm.network "private_network", ip: "192.168.111.113"
    api.vm.hostname = "api"
  end
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "site.yml"
    ansible.host_vars = {
      "n01" => {"new_hostname" => "n01",
                  "ansible_ssh_host" => "192.168.111.111",
                  "ansible_ssh_port" => "22"},
      "ctl" => {"new_hostname" => "ctl",
                  "ansible_ssh_host" => "192.168.111.112",
                  "ansible_ssh_port" => "22"},
      "api" => {"new_hostname" => "api",
                  "ansible_ssh_host" => "192.168.111.113",
                  "ansible_ssh_port" => "22"}
    }
    ansible.groups = {
      "lb" => ["n01"],
      "api" => ["api"],
      "ctl" => ["ctl"]
    }
  end
end
