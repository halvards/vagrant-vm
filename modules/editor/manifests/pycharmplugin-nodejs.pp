class editor::pycharmplugin-nodejs($idea_edition = 'PyCharm') {
  editor::ideaplugin { "nodejs-${idea_edition}":
    plugin_name  => 'nodejs',
    version      => '125.87',
    filetype     => 'jar',
    update_id    => '12793',
    idea_edition => $idea_edition,
  }
}

