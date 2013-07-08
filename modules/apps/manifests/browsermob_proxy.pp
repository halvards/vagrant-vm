#
# See http://opensource.webmetrics.com/browsermob-proxy/ for downloads
# and https://github.com/webmetrics/browsermob-proxy for API
#
class apps::browsermob_proxy($port = '9090', $jdk = 'oraclejdk7') {
  include utils::base
  include utils::netcat
  include vagrant::user
  if ! defined(Class["java::$jdk"]) {
    class { "java::$jdk": }
  }

  $username = 'vagrant'

  $browsermob_proxy_version = '2.0-beta-8'
  $browsermob_proxy_zip_filename = "browsermob-proxy-${browsermob_proxy_version}-bin.zip"
  $browsermob_proxy_dir = '/opt/browsermob-proxy'

  wget::fetch { 'browsermob-proxy':
    source      => "https://s3-us-west-1.amazonaws.com/lightbody-bmp/${browsermob_proxy_zip_filename}",
    destination => "/vagrant-share/apps/${browsermob_proxy_zip_filename}",
  }

  exec { 'extract-browsermob-proxy':
    command   => "/usr/bin/unzip -q /vagrant-share/apps/${browsermob_proxy_zip_filename} -d /opt",
    creates   => "/opt/browsermob-proxy-${browsermob_proxy_version}/bin/browsermob-proxy",
    logoutput => true,
    require   => [Wget::Fetch["browsermob-proxy"], Package['unzip']],
  }

  file { "${browsermob_proxy_dir}":
    ensure  => link,
    target  => "/opt/browsermob-proxy-${browsermob_proxy_version}",
    require => Exec['extract-browsermob-proxy'],
  }

  service { 'browsermob-proxy':
    provider   => base,
    enable     => true,
    ensure     => running,
    hasrestart => false,
    hasstatus  => false,
    start      => "/bin/bash -c '${browsermob_proxy_dir}/bin/browsermob-proxy --port ${port} >> /var/log/browsermob-proxy.log 2>&1 &'",
    status     => "/bin/nc -4z localhost ${port}",
    require    => [File["${browsermob_proxy_dir}"], Class['utils::netcat']],
  }
}

