class gitlab::git (

  $git_packagename = $::gitlab::params::git_packagename,

) inherits gitlab::params {

  include '::ius'

  package { $git_packagename:
    ensure  => present,
    require => Yumrepo['ius'],
  }

}
