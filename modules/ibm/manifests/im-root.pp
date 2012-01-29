# IBM Installation Manager installed as root. Required by DB2
class ibm::im-root {
  include ibm::im-prereqs

  $ibm_im_extract_location = '/vagrant-share/apps/ibmrepos/im'
  $ibm_im_root_location = '/opt/IBM/InstallationManager'

  exec { 'install-ibm-im-root':
    command => "${ibm_im_extract_location}/installc -acceptLicense",
    creates => $ibm_im_root_location,
    require => Class['Ibm::Im-prereqs'],
  }
}

