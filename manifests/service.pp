# manage irods service
#
# iRODS started by `irodsctl` (as is the case when setup.py is run) is
# not detected by systemd. So we monkey patch the Service{} start
# parameter to ensure `irodsctl` is stopped before starting with systemd.
#
class irods::service {

  include irods::globals
  include irods::namespace

  $irodsctl_stop = "su irods -c '${::irods::globals::irods_home}/irodsctl stop' 2>&1"

  systemd::unit_file { 'irods.service':
    source => "puppet:///modules/${module_name}/irods.service",
  }
  -> service { 'irods':
    ensure  => 'running',
    start   => "${irodsctl_stop} && systemctl start irods",
    require => Service['irods-namespace'],
  }
}
