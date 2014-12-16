class gitlab::params {

  $git_packagename     = 'git2u'
  $system_ruby_version = '2.0.0'

  $db_root_password    = 'UNSET'
  $db_git_password    = '*7E369C5434192074773D7D263629F458C656DFC6'

  $gitlab_revision     = '7-5-stable'
  $gitlab_host         = ${::fqdn}
  $gitlab_port         = '80'
  $gitlab_email        = "git@${::domain}"
  $unicorn_workers     = (${::processorcount} + 1)

}
