class gitlab::db::install (

  $db_root_password = ::gitlab::params::db_root_password,
  $db_git_password  = ::gitlab::params::db_git_password,

) inherits gitlab::params {

  include '::mysql::server'

  class { '::mysql::server':
    root_password           => "$db_root_password",
    remove_default_accounts => true,
    users                   => {
      'git@localhost' => {
        ensure        => 'present',
        password_hash => "$db_git_password",
      },
    }
    grants                  => {
      'git@localhost/gitlabhq_production.*' => {
        ensure  => present,
        options => ['GRANT'],
      },
    }
  }

}
