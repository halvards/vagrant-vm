# Install the Ruby plugin for IntelliJ IDEA
class editor::idea-ruby-plugin($idea_edition) {

  $idea_ruby_plugin_version = '4.5.0.20130108' # requires IntelliJ 12
  $idea_config_dir = $idea_edition ? {
    'IC' => '/home/vagrant/.IdeaIC12',
    'IU' => '/home/vagrant/.IntelliJIdea12',
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

