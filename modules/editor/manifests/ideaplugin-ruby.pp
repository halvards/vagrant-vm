class editor::ideaplugin-ruby($idea_edition = 'IU') {
  editor::ideaplugin { "ruby-${idea_edition}":
    plugin_name  => 'ruby',
    version      => '5.4.0.20130703',
    filetype     => 'zip',
    update_id    => '13661',
    idea_edition => $idea_edition,
  }
}

