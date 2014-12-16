class gitlab::gitlab-shell {

  exec { 'gitlabi-shell-bundle-install':
    user      => $rvm::user,
    command   => "bash -c 'source ~/.rvm/scripts/rvm; bundle exec rake gitlab:shell:install[v2.1.0] REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production'",
    unless    => '[ -d /home/git/gitlab-shell ]',
    logoutput => 'on_failure',
    path      => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
  }

}
