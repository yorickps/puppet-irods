# installs only the icommands
class irods::client (
  $core_version = $irods::params::core_version,
  $package_install_options = $irods::globals::package_install_options,
) inherits irods::params {

  irods::lib::install { 'irods-icommands':
    packages                => 'irods-icommands',
    core_version            => $core_version,
    package_install_options => $package_install_options,
  }

}
