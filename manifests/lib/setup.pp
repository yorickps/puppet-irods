# Run the iRODS interactive setup script, taking inputs from a response
# file. The response file is different on provider and consumer servers.
#
# Logging to $setup_log_file. The setup script also creates a log in
# /var/lib/irods/log/setup_log.txt
#
define irods::lib::setup (
  $setup_rsp_file = undef,
  $setup_rsp_tmpl = undef,
  $setup_log_file = 'irods_setup.log',
) {
  include irods::namespace

  $staging_dir     = '/var/lib/irods/.puppetstaging'
  $setup_py        = '/var/lib/irods/scripts/setup_irods.py'
  $db_vendor       = $::irods::provider::db_vendor

  # Some patches to make mysql work as a backend
  $fix_sql_files = ['/var/lib/irods/packaging/sql/icatSysTables.sql', '/var/lib/irods/packaging/sql/mysql_functions.sql']

  $fix_sql_files.each |String $file| {
    file_line { "storage_engine_${file}":
      path   => $file,
      line   => 'SET SESSION default_storage_engine=\'InnoDB\';',
      match  => '^SET SESSION .*storage_engine=.*',
      before => Exec['irods-provider-setup'],
    }
  }

  # Bail out if database is already set up
  file_line { 'bail_out_database_exists':
    path   => '/var/lib/irods/scripts/irods/database_interface.py',
    line   => '                if database_connect.irods_tables_in_database(irods_config, cursor): return',
    after  => '^            try:',
    before => Exec['irods-provider-setup'],
  }

  file { $staging_dir:
    ensure => 'directory',
  }

  # Response file as input to the setup script.
  -> file { "${staging_dir}/${setup_rsp_file}":
    ensure  => 'file',
    content => template("irods/${setup_rsp_tmpl}"),
    mode    => '0600',
  }

  -> exec { 'irods-provider-setup':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => "/usr/bin/nsenter --uts=/root/irods-ns-uts python ${setup_py} < ${staging_dir}/${setup_rsp_file} > ${$staging_dir}/${setup_log_file} 2>&1",
    unless  => 'test -f /etc/irods/server_config.json',
    require => Service['irods-namespace'],
  }

}
