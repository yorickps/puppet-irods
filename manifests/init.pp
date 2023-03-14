# Class: supervisor
#
#  @summary
#    This module manages irods
#
#  @param db_vendor
#  @param db_plugin_version
#  @param db_name
#  @param db_user
#  @param db_password
#  @param db_srv_host
#  @param db_srv_port
#  @param db_password_salt
#  @param do_setup
#  @param re_rulebase_set
#  @param server_config_json
#  @param manage_repo
#  @param core_packages
#
class irods (
  String $db_vendor,
  String $db_plugin_version,
  String $db_name,
  String $db_user,
  Sensitive[String] $db_password,
  Stdlib::Fqdn $db_srv_host,
  Stdlib::Port::Unprivileged $db_srv_port,
  String $db_password_salt,
  Boolean $do_setup,
  Array $re_rulebase_set,
  Stdlib::Absolutepath $server_config_json,
  Boolean $manage_repo,
  Array $core_packages,
){

}
