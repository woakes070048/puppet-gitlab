class gitlab::users {

  user { 'git':
    ensure     => 'present',
    comment    => 'GitLab',
    system     => true,
    managehome => true,
    home       => '/home/git',
    shell      => '/bin/bash',
  }
  exec { '/usr/bin/ssh-keygen -q -N "" -t rsa -f /home/git/.ssh/id_rsa':
    user      => 'git',
    creates   => '/home/git/.ssh/id_rsa',
    logoutput => on_failure,
    require   => User['git'],
  }
  file { '/home/git/.gitconfig':
    ensure  => 'file',
    owner   => 'git',
    group   => 'git',
    content => template('gitlab/gitconfig.erb'),
    require => User['git'],
  }
  file { '/home/git':
    ensure  => 'directory',
    owner   => 'git',
    group   => 'git',
    mode    => '0755',
    require => User['git'],
  }
  file { '/etc/sudoers.d/gitlab':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/gitlab/gitlab",
  }

}
