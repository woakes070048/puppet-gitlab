class gitlab::gitlab (

  $db_git_password = $::gitlab::params::db_git_password,

  $gitlab_revision = $::gitlab::params::gitlab_revision,
  $gitlab_host     = $::gitlab::params::gitlab_host,
  $gitlab_port     = $::gitlab::params::gitlab_port,
  $gitlab_email    = $::gitlab::params::gitlab_email,

  $unicorn_workers = $::gitlab::params::unicorn_workers,

) inherits gitlab::params {

  File {
    owner => 'git',
  }

  vcsrepo { '/home/git/gitlab':
    ensure   => 'present',
    providor => 'git',
    source   => 'https://gitlab.com/gitlab-org/gitlab-ce.git',
    revision => "${revision}",
    require  => User['git'],
  }
  file { '/home/git/config/gitlab.yml':
    ensure  => 'file',
    content => template('gitlab/gitlab.yml.erb'),
    require => Vcsrepo['/home/git/gitlab'],
  }
  file { '/home/git/gitlab/log':
    ensure  => 'directory',
    recurse => true,
    mode    => '0777',
    require => Vcsrepo['/home/git/gitlab'],
  }
  file { '/home/git/gitlab/tmp':
    ensure  => 'directory',
    recurse => true,
    mode    => '0777',
    require => Vcsrepo['/home/git/gitlab'],
  }
  file { '/home/git/gitlab-satellites':
    ensure  => 'directory',
    mode    => '0750',
    require => User['git'],
  }
  file { '/home/git/gitlab/public/uploads':
    ensure  => 'directory',
    recurse => true,
    mode    => '0755',
    require => Vcsrepo['/home/git/gitlab'],
  }
  file { '/home/git/gitlab/config/unicorn.rb':
    ensure  => 'file',
    content => template('gitlab/unicorn.rb.erb'),
    require => Vcsrepo['/home/git/gitlab'],
  }
  file { '/home/git/gitlab/config/initializers/rack_attack.rb':
    ensure  => 'file',
    source  => 'puppet:///modules/gitlab/rack_attack.rb',
    require => Vcsrepo['/home/git/gitlab'],
  }
  file { '/home/git/gitlab/config/resque.yml':
    ensure  => 'file',
    source  => 'puppet:///modules/gitlab/resque.yml',
    require => Vcsrepo['/home/git/gitlab'],
  }
  file { '/home/git/gitlab/config/database.yml':
    ensure  => 'file',
    content => template('gitlab/database.mysql.erb'),
    require => Vcsrepo['/home/git/gitlab'],
  }
  exec { 'gitlab-bundle-install':
    user      => $rvm::user,
    command   => "bash -c 'source ~/.rvm/scripts/rvm; bundle install --deployment --without development test postgres aws'",
    unless    => "bash -c 'source ~/.rvm/scripts/rvm ; gem list | grep gitlab_meta'",
    logoutput => 'on_failure',
    path      => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
    require   => [
      Vcsrepo['/home/git/gitlab'],
      Class['gitlab::ruby'],
      Class['gitlab::db'],
      Class['gitlab::redis'],
    ],
  }
  file { '/etc/init.d/gitlab':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source  => 'puppet:///modules/gitlab/centos-init',
  }
  service { 'gitlab':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [
      Exec['gitlab-bundle-install'],
      File['/etc/init.d/gitlab'],
    ],
  }
  file { '/etc/logrotate.d/gitlab':
    ensure => 'file'
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source  => 'puppet:///modules/gitlab/logrotate',
  }

}
