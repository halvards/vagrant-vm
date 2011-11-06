class rvm::system_install {
  include rvm::system
  include vagrant::user

  rvm::system_user { 'vagrant': }
}

