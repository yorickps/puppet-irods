# The RENCI RPM packages contain overlapping files (especially the
# icommands) so we have to try to ensure only one core package is
# installed at at time - handling cases, for example, when an
# irods::client node is changed to a irods::resource node.
define irods::lib::install (
  Array $packages               = undef,
  Array $engine_plugin_packages = [],
  $core_version                 = $irods::params::core_version,
  $engine_plugin_release        = $irods::params::engine_plugin_release,
  $manage_repo                  = $irods::params::manage_repo,
  $package_install_options      = '',
) {

  if $packages {
    $install_pkgs = $packages
  } else {
    $install_pkgs = [$packages]
  }

  if $engine_plugin_packages {
    $install_engine_plugins = $engine_plugin_packages
  } else {
    $install_engine_plugins = [$engine_plugin_packages]
  }

  case $::osfamily {
    'RedHat': {
      $core_packages = $irods::params::core_packages
      $rm_pkgs = difference($core_packages, $install_pkgs)
      if $manage_repo {
        class {'irods::yum::install':
          before => Package[$install_pkgs],
        }
      }
    }
    default: {
      $rm_pkgs = []
    }
  }

  package { $rm_pkgs:
    ensure => absent,
  }
  -> package { $install_pkgs:
    ensure          => $core_version,
    install_options => $package_install_options,
  } ->
  package { $install_engine_plugins:
    ensure          => "${core_version}${engine_plugin_release}",
    install_options => $package_install_options,
  }


}
