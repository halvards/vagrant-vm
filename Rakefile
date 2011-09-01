require 'vagrant'

configs = {:centos => [:plain, :rubyee, :go, :mqseries, :ibmwas, :ibmrtc, :ibmwps, :gnome, :mercurial, :oraclexe, :webdav],
           :ubuntu => [:plain, :go]}

configs.each do |os_type, vm_types|
  namespace os_type do
    vm_types.each do |vm_type|
      namespace vm_type do
        vm_name = "#{vm_type.to_s}-#{os_type.to_s}64"
        vm_directory = File.join(File.expand_path(File.dirname(__FILE__)), vm_name)
        vagrant_env = Vagrant::Environment.new(:cwd => vm_directory)
        vagrant_env.ui = Vagrant::UI::Shell.new(vagrant_env, Thor::Base.shell.new)

        desc "Start #{vm_name} (Creates the VM on first run)"
        task :up do
          puts "VM directory: #{vm_directory}"
          vagrant_env.cli("up")
        end

        desc "Destroy and recreate #{vm_name} from base box"
        task :recreate => [:destroy, :up]

        desc "Delete the #{vm_name} VM (Recreate with 'up')"
        task :destroy do
          vagrant_env.cli("destroy")
        end

        desc "Shutdown #{vm_name} (avoid, instead ssh to VM and execute 'sudo halt')"
        task :halt do
          vagrant_env.cli("halt")
        end

        desc "Provision #{vm_name} without restarting"
        task :provision do
          vagrant_env.cli("provision")
        end

        desc "Shutdown and restart #{vm_name}"
        task :reload do
          vagrant_env.cli("reload")
        end

        desc "Resume the suspended #{vm_name}"
        task :resume do
          vagrant_env.cli("resume")
        end

        desc "SSH to #{vm_name}"
        task :ssh do
          vagrant_env.cli("ssh")
        end

        desc "Output .ssh/config syntax for connecting manually to #{vm_name} (use for scp)"
        task :ssh_config do
          vagrant_env.cli("ssh_config")
        end

        desc "Show status of #{vm_name}"
        task :status do
          vagrant_env.cli("status")
        end

        desc "Suspend #{vm_name} (bring back with 'resume')"
        task :suspend do
          vagrant_env.cli("suspend")
        end
      end
    end
  end
end

