class editor::rubymineplugin-nodejs($idea_edition = 'RubyMine') {
  editor::ideaplugin { "nodejs-${idea_edition}":
    plugin_name  => 'nodejs',
    version      => '125.87',
    filetype     => 'jar',
    update_id    => '12793',
    idea_edition => $idea_edition,
  }
}

