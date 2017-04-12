# -*- mode: ruby -*-
# vi: set ft=ruby :

playbook_file = 'ansible/vagrant.yml'

Vagrant.configure("2") do |config|

  config.vm.define "consul1" do |consul1|
    consul1.vm.box = "ubuntu/trusty64"
    consul1.vm.hostname = "consul1"
    consul1.vm.network "private_network", ip: "192.168.77.20"
    consul1.vm.provision "ansible" do |ansible|
      ansible.playbook = playbook_file
      ansible.verbose = true
    end
  end

  config.vm.define "consul2" do |consul2|
    consul2.vm.box = "ubuntu/trusty64"
    consul2.vm.hostname = "consul2"
    consul2.vm.network "private_network", ip: "192.168.77.21"
    consul2.vm.provision "ansible" do |ansible|
      ansible.playbook = playbook_file
      ansible.verbose = true
    end
  end

  config.vm.define "vault" do |vault |
    vault.vm.box = "ubuntu/trusty64"
    vault.vm.hostname = "vault"
    vault.vm.network "private_network", ip: "192.168.77.25"
    vault.vm.provision "ansible" do |ansible|
      ansible.playbook = playbook_file
      ansible.verbose = true
    end
  end

  config.vm.define "appserver" do |appserver|
    appserver.vm.box = "ubuntu/trusty64"
    appserver.vm.hostname = "app1"
    appserver.vm.network "private_network", ip: "192.168.77.10"
    appserver.vm.provision "ansible" do |ansible|
      ansible.playbook = playbook_file
      ansible.verbose = true
    end
  end

end
