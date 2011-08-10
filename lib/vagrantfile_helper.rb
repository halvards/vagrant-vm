require 'uri'
require 'net/http'

module VagrantfileHelper

  def hostname(box_name)
    hostname_prefix_file = File.join(File.dirname(__FILE__), "../#{box_name}/hostname_do_not_check_in.txt")
    raise "No hostname file present: #{hostname_prefix_file}" unless File.exists?(hostname_prefix_file)
    hostname_prefix = File.read(hostname_prefix_file)
    "#{hostname_prefix}.#{box_name}.vagrant.local"
  end

  def basebox(url)
    basebox_directory = File.expand_path('../boxes/', File.dirname(__FILE__))
    Dir.mkdir(basebox_directory) unless File.directory?(basebox_directory)
    basebox_uri = URI.parse(url)
    basebox_filename = File.basename(basebox_uri.path)
    basebox_file = File.join(basebox_directory, basebox_filename)
    if !File.exists?(basebox_file)
      puts "Downloading basebox file #{basebox_filename} to #{basebox_directory}"
      Net::HTTP.start(basebox_uri.host) { |http|
        response = http.get(basebox_uri.path)
        open(basebox_file, 'wb') { |file|
          file.write(response.body)
        }
      }
    end
    basebox_file
  end

  def set_defaults(config, box_name, prefix)
    # The name of the virtual machine used by Vagrant
    config.vm.box = box_name

    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system.
    if box_name.end_with?('centos64')
      config.vm.box_url = basebox('http://dl.dropbox.com/u/36836372/centos56_64-veewee.box')
    elsif box_name.end_with?('ubuntu64')
      config.vm.box_url = basebox('http://files.vagrantup.com/lucid64.box')
    else
      raise "Default basebox URL could not be found for #{box_name}"
    end

    # Assign this VM a unique hostname
    config.vm.host_name = hostname("#{prefix}-#{box_name}")

    # Share an additional folder to the guest VM. The first argument is
    # an identifier, the second is the path on the guest to mount the
    # folder, and the third is the path on the host to the actual folder.
    config.vm.share_folder "vagrant-share", "/vagrant-share", "../share"

    # Enable provisioning with Puppet stand alone.  Puppet manifests
    # are contained in a directory path relative to this Vagrantfile.
    # You will need to create the manifests directory and a manifest in
    # a .pp file with the same name as the box.
    config.vm.provision :puppet do |puppet|
      puppet.manifest_file = "#{prefix}-#{box_name}.pp"
      puppet.module_path = '../modules'
    end
  end

end

