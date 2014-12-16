class gitlab::db::install (

  $db_root_password = ::gitlab::params::db_root_password,
  $db_git_password  = ::gitlab::params::db_git_password,

) inherits gitlab::params {

  class { '::mysql::server':
    root_password           => "${db_root_password}",
    remove_default_accounts => true,
    override_options        => {
      'mysqld' => {
        'default-storage-engine' => 'InnoDB',
      },
    }
    users                   => {
      'git@localhost' => {
        ensure        => 'present',
        password_hash => "${db_git_password}",
      },
    }
    grants                  => {
      'git@localhost/gitlabhq_production.*' => {
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => [ 'SELECT', 'LOCK TABLES', 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'DROP', 'INDEX', 'ALTER' ],
        table      => 'gitlabhq_production.*',
        user       => 'git@localhost',
      },
    }
    databases               => {
      'gitlabhq_production' => {
        ensure  => 'present',
        charset => 'utf8',
        collate => 'utf8_unicode_ci',
      },
    }
  }

}
