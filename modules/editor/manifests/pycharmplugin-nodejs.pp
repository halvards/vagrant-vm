class editor::pycharmplugin-nodejs($idea_edition = 'PyCharm') {
  editor::ideaplugin { "nodejs-${idea_edition}":
    plugin_name  => 'nodejs',
    version      => '129.714',
    filetype     => 'zip',
    update_id    => '13546',
    idea_edition => $idea_edition,
  }
}

