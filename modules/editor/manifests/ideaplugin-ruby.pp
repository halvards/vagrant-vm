class editor::ideaplugin-ruby($idea_edition = 'IU') {
  editor::ideaplugin { "ruby-${idea_edition}":
    plugin_name  => 'ruby',
    version      => '5.4.0.20130404',
    filetype     => 'zip',
    update_id    => '13083',
    idea_edition => $idea_edition,
  }
}

