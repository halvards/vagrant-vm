# Install the Ruby plugin for IntelliJ IDEA
class editor::idea-ruby-plugin($idea_edition) {

  $idea_ruby_plugin_version = '4.0.3.20120406' # requires IntelliJ 11.x or later
  #$idea_ruby_plugin_version = '3.2.4' # latest version supported by IntelliJ IDEA 10
  $idea_config_dir = $idea_edition ? {
    'IC' => '/home/vagrant/.IdeaIC11',
    'IU' => '/home/vagrant/.IntelliJIdea11',
  }

  wget::fetch { "idea-ruby-plugin":
    source => "http://download-ln.jetbrains.com/ruby/ruby-${idea_ruby_plugin_version}.zip",
    destination => "/vagrant-share/apps/ruby-${idea_ruby_plugin_version}.zip",
  }

  exec { "extract-idea-ruby-plugin":
    command => "/usr/bin/unzip /vagrant-share/apps/ruby-${idea_ruby_plugin_version}.zip -d ${idea_config_dir}/config/plugins",
    creates => "$idea_config_dir/config/plugins/ruby",
    require => Wget::Fetch["idea-ruby-plugin"],
  }
}

