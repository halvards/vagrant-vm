# IBM Installation Manager installed as user vagrant
class ibm::im-user {
  include ibm::im-prereqs
  include vagrant::user

  $ibm_im_extract_location = '/vagrant-share/apps/ibmrepos/im'
  $ibm_im_location = '/home/vagrant/IBM/InstallationManager'

  exec { 'install-ibm-im':
    command => "${ibm_im_extract_location}/userinstc -acceptLicense",
    user    => 'vagrant',
    creates => $ibm_im_location,
    require => Class['Ibm::Im-prereqs'],
  }
}

