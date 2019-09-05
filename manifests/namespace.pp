# manage irods namespace
#
class irods::namespace (
  String $irods_hostname = '',
) {

  include irods::globals

  file { '/etc/sysconfig/irods-namespace':
    ensure  => file,
    content => "IRODS_HOSTNAME=${irods_hostname}\n",
    owner   => 'root',
    group   => 'root',
  }
  -> file { '/usr/local/sbin/setup-irods-namespace':
    ensure => file,
    source => "puppet:///modules/${module_name}/setup-irods-namespace",
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }
  -> systemd::unit_file { 'irods-namespace.service':
    source => "puppet:///modules/${module_name}/irods-namespace.service",
  }
  -> service { 'irods-namespace':
    ensure => 'running',
  }
}
