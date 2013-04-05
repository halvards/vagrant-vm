class editor::ideaplugin-ruby($idea_edition = 'IU') {
  editor::ideaplugin { "ruby-${idea_edition}":
    plugin_name  => 'ruby',
    version      => '5.0.0.20130314',
    filetype     => 'zip',
    update_id    => '12909',
    idea_edition => $idea_edition,
  }
}

