class gitlab::db  inherits gitlab::params {

  include '::gitlab::db::install'
  include '::gitlab::db::service'

}
