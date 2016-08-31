# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "packify"

  config.vm.provider "vmware_fusion" do |v|
    v.gui = false
  end

  config.vm.provision "shell", inline: <<-SHELL
    vagrant box list
    sysctl -a | grep hv
  SHELL
end
