# -*- mode: ruby -*-
# vim: set ft=ruby :

# Провайдер из переменной окружения или virtualbox по умолчанию
PROVIDER = ENV["VAGRANT_DEFAULT_PROVIDER"] || "virtualbox"

# Имя бокса можно переопределить через переменную окружения:
#   VAGRANT_BOX=almalinux9-stand vagrant up --provider=libvirt
BOX_NAME = ENV['VAGRANT_BOX'] || 'generic/ubuntu2204'

MACHINES = {
  :nginx => {
    :box_name => BOX_NAME,
    :vm_name => "nginx",
    :mem => 768,
    :cpus => 1,
    :net => [
      ["192.168.11.150", 2, "255.255.255.0", "mynet"],
    ]
#  },
#  :nginx2 => {
#    :box_name => BOX_NAME,
#    :vm_name => "nginx2",
#    :mem => 768,
#    :cpus => 1,
#    :net => [
#      ["192.168.11.151", 2, "255.255.255.0", "mynet"],
#    ]
  }
}

Vagrant.configure("2") do |config|

  # Базовый порт для проброса (только VirtualBox)
  host_port = 8080

  MACHINES.each do |boxname, boxconfig|

    config.vm.define boxname do |box|

      box.vm.box = boxconfig[:box_name]
      box.vm.host_name = boxconfig[:vm_name]

      # --- Настройки провайдера ---
      if PROVIDER == "libvirt"
        box.vm.provider :libvirt do |lv|
          lv.memory = boxconfig[:mem]
          lv.cpus = boxconfig[:cpus]
        end
      else
        box.vm.provider "virtualbox" do |v|
          v.memory = boxconfig[:mem]
          v.cpus = boxconfig[:cpus]
        end
      end

      # --- Сеть: private_network (по-разному для провайдеров) ---
      boxconfig[:net].each do |ipconf|
        if PROVIDER == "libvirt"
          box.vm.network("private_network",
            ip: ipconf[0],
            netmask: ipconf[2],
            libvirt__network_name: ipconf[3]
          )
        else
          box.vm.network("private_network",
            ip: ipconf[0],
            adapter: ipconf[1],
            netmask: ipconf[2],
            virtualbox__intnet: ipconf[3]
          )
        end
      end

      if boxconfig.key?(:public)
        box.vm.network "public_network", boxconfig[:public]
      end

      # --- Проброс портов (только VirtualBox) ---
      if PROVIDER == "virtualbox"
        box.vm.network :forwarded_port,
          guest: 8080,
          host: host_port,
          host_ip: "127.0.0.1"
        host_port += 1
      end

      # --- Провижн ---
      box.vm.provision "shell", inline: <<-SHELL
        mkdir -p ~root/.ssh
        cp ~vagrant/.ssh/auth* ~root/.ssh 2>/dev/null || true
        sudo sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
        systemctl restart sshd
      SHELL
    end
  end
end
