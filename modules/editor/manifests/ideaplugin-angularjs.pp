class editor::ideaplugin-angularjs($idea_edition = 'IU') {
  editor::ideaplugin { "angularjs-${idea_edition}":
    plugin_name  => 'angularjs',
    version      => '0.1.8',
    filetype     => 'zip',
    update_id    => '13638',
    idea_edition => $idea_edition,
  }
}

