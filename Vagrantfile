# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  SINGLE_MACHINE_SETUP = {
    'sprockets-master' => {
      :box => 'ubuntu/trusty64',
      :network => {
        :private_network => {:ip => '192.168.50.8'},
      },
      :vm => {
        :memory => 2048,
        :cpus => 2
      }
    },
  }

  machines = SINGLE_MACHINE_SETUP
  ANSIBLE_RAW_SSH_ARGS = ['-o IdentitiesOnly=yes']

  # we only do the provisioning on the last machine - thats why we have machine_index
  machines.keys.each.with_index do |machine_name, machine_index|
    config.vm.define machine_name do |machine|
      machine.vm.hostname = machine_name

      machines[machine_name].each do |machine_param, value|
        if machine_param == :vm
          machine.vm.provider "virtualbox" do |v|
            value.each do |vm_param, vm_value|
              v.send("#{vm_param}=", vm_value)
            end
          end
        elsif value.kind_of?(Hash)
          value.each do |k,v|
            # machine.vm.network :private_network, {:ip => 1.2.3.4}
            machine.vm.send(machine_param, k, v)
          end
        elsif value.kind_of?(Array)
          machine.vm.send(machine_param, value)
        else
          # machine.box = "ubuntu/trusty64"
          machine.vm.send("#{machine_param}=", value)
        end
      end

      ANSIBLE_RAW_SSH_ARGS << "-o IdentityFile=.vagrant/machines/#{machine_name}/virtualbox/private_key"

      if machine_index == machines.length - 1
        machine.vm.provision :ansible do |ansible|
          ansible.limit = 'all'
          ansible.playbook = 'ansible/site.yml'
          ansible.groups = {
            'vagrant-boxes' => machines.keys.map(&:to_s)
          }
          ansible.sudo = true
          ansible.extra_vars = {
            'ansible_ssh_user' => 'vagrant'
          }
          ansible.raw_ssh_args = ANSIBLE_RAW_SSH_ARGS

          # # make it very verbose
          # ansible.raw_arguments = ['-vvv']

          ## Run only some tags
          # TAGS=local_env,make_bash_profile vagrant provision
          if ENV["TAGS"]
            ansible.tags = ENV["TAGS"].split(",")
            ansible.skip_tags = ['always']
          end
        end
      end
    end
  end

end
