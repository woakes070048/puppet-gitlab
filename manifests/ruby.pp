class gitlab::ruby (

  $system_ruby_version = $::gitlab::params::system_ruby_version,

) inherits gitlab::params {

  rvm_system_ruby { $system_ruby_version:
    ensure      => present,
    default_use => true,
  }

  rvm_gem { "${system_ruby_version}/bundler":
    ensure  => present,
    require => Rvm_system_ruby["${system_ruby_version}"],
  }

  rvm::system_user { 'git': }

}
