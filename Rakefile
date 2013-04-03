require 'vagrant'

configs = {:centos => [
                       :gnome,
                       :go,
                       :ibmrtc,
                       :ibmwas,
                       :ibmwid,
                       :mcollective,
                       :mercurial,
                       :mqseries,
                       :oraclexe,
                       :plain,
                       :postgres,
                       :rubyee,
                       :webdav,
                      ],
           :ubuntu => [
                       :go,
                       :gui,
                       :javadev,
                       :lab,
                       :plain,
                       :postgres,
                       :riak,
                       :sonar,
                      ]
          }

configs.each do |os_type, vm_types|
  namespace os_type do
    vm_types.each do |vm_type|
      namespace vm_type do
        vm_name = "#{vm_type.to_s}-#{os_type.to_s}64"
        vm_directory = File.join(File.expand_path(File.dirname(__FILE__)), vm_name)
        vagrant_env = Vagrant::Environment.new({:cwd => vm_directory,
                                                :ui_class => Vagrant::UI::Colored})

        desc "Start #{vm_name} (Creates the VM on first run)"
        task :up, :host do |task, args|
          puts "VM directory: #{vm_directory}"
          vagrant_env.cli("up", args[:host])
        end

        desc "Start #{vm_name} and SSH in"
        task :start => [:up, :ssh]

        desc "Destroy and recreate #{vm_name} from base box"
        task :recreate => [:destroy, :up]

        desc "Delete the #{vm_name} VM (Recreate with 'up')"
        task :destroy, :host do |task, args|
          vagrant_env.cli("destroy", "--force", args[:host])
        end

        desc "Shutdown #{vm_name} (avoid, instead ssh to VM and execute 'sudo halt')"
        task :halt, :host do |task, args|
          vagrant_env.cli("halt", args[:host])
        end

        desc "Provision #{vm_name} without restarting"
        task :provision, :host do |task, args|
          vagrant_env.cli("provision", args[:host])
        end

        desc "Shutdown and restart #{vm_name}"
        task :reload, :host do |task, args|
          vagrant_env.cli("reload", args[:host])
        end

        desc "Resume the suspended #{vm_name}"
        task :resume, :host do |task, args|
          vagrant_env.cli("resume", args[:host])
        end

        desc "SSH to #{vm_name}"
        task :ssh, :host do |task, args|
          vagrant_env.cli("ssh", args[:host])
        end

        desc "Output .ssh/config syntax for connecting manually to #{vm_name} (use for scp)"
        task :ssh_config, :host do |task, args|
          vagrant_env.cli("ssh_config", args[:host])
        end

        desc "Show status of #{vm_name}"
        task :status, :host do |task, args|
          vagrant_env.cli("status", args[:host])
        end

        desc "Suspend #{vm_name} (bring back with 'resume')"
        task :suspend, :host do |task, args|
          vagrant_env.cli("suspend", args[:host])
        end
      end
    end
  end
end

