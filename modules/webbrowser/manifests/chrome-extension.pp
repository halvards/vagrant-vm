define webbrowser::chrome-extension($id, $update_url='https://clients2.google.com/service/update2/crx') {
  include webbrowser::chrome

  $username = 'vagrant'
  $extension_dir = "/home/${username}/.config/chromium/Default/External Extensions"

  file { "${extension_dir}/${id}.json":
    content => "{\n  \"external_update_url\": \"${update_url}\"\n}",
  }
}

