class editor::ideaplugin-python($idea_edition = 'IU') {
  editor::ideaplugin { "python-${idea_edition}":
    plugin_name  => 'python',
    version      => '2.10.1',
    filetype     => 'zip',
    update_id    => '12812',
    idea_edition => $idea_edition,
  }
}

