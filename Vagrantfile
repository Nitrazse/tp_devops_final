Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 600

  config.vm.define "k3s-node" do |node|
    node.vm.box = "debian/bookworm64"
    node.vm.hostname = "k3s-node"
    node.vm.network "private_network", ip: "192.168.56.10"
    node.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus   = 2
      vb.name   = "k3s-node"
    end
    node.vm.provision "shell", path: "scripts/install_k3s.sh"
  end

  config.vm.define "monitoring" do |mon|
    mon.vm.box = "debian/bookworm64"
    mon.vm.hostname = "monitoring"
    mon.vm.network "private_network", ip: "192.168.56.11"
    mon.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus   = 2
      vb.name   = "monitoring"
    end
    mon.vm.provision "shell", path: "scripts/install_monitoring.sh"
  end
end
