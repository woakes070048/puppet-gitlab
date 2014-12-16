class gitlab::redis {

  class { '::redis':
    system_sysctl => true,
  }

}
