Vagrant.configure("2") do |config|

  config.vm.define "k3s-node" do |node|
    node.vm.box = "debian/bookworm64"
    node.vm.hostname = "k3s-node"

    # IP fixe pour pouvoir communiquer avec Ansible
    node.vm.network "private_network", ip: "192.168.56.10"

    # Ressources
    node.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus   = 2
      vb.name   = "k3s-node"
    end

    # Installation automatique de k3s
    node.vm.provision "shell", path: "scripts/install_k3s.sh"
  end

end