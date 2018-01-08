# Configures foreman_scap_client and sets cron tasks to run it
#
# === Parameters:
#
# $ensure::           Passed to the rubygem-foreman_scap_client package.
#                     Default: present
#
# $server::           foreman proxy url where arf reports should be sent
#
# $port::             port of foreman proxy that is used as $server
#
# $ca_file::          path to file of certification authority that issued client's certificate
#                     May be overriden if $::rh_certificate_repo_ca_file (from Facter) is found
#
# $host_certificate:: path to host certificate, usually puppet agent certificate
#                     May be overriden if $::rh_certificate_consumer_host_cert (from Facter) is found
#
# $host_private_key:: path to host private key, usually puppet agent private key
#                     May be overriden if $::rh_certificate_consumer_host_key (from Facter) is found
#
# $foreman_repo_rel:: add / manage foreman-plugins yum repo and set to release version. Eg  '1.14'
#
# $foreman_repo_key:: RPM Key source file for foreman-plugins repo. Note: Currently, packages are not signed.
#                     Unless set to an alternative file source, URL will be used.
#
# foreman_repo_src::  Alternative baseurl for The Foreman plugins repository
#
# foreman_repo_gpg_chk:: Enable / disable GPG checks. Directly passed to Yumrepo resource
#
# $policies::         Array of policies that should be configured, each member represent
#                     one policy in form of hash
#                     Policy hash must have following structure
#
#                       { "id" => 1, "hour" => "*", "minute" => "*", "month" => "*",
#                         "monthday" => "*", "weekday" => "*", "profile_id" => '',
#                         "content_path" => '/usr/share/...',
#                         "tailoring_path" => '/var/lib...'
#                       }
#
#                     note that profile_id may be empty (for default profile)
#                     id is number representing id of policy in foreman
#                     content_path is path to DS file that contains profile
#
#                     if it's not array, it's automatically converted to it, so you can
#                     even specify just one policy as a hash
#                     type:array
# $fetch_remote_resources:: Enable / disable --fetch-remote-resources when running oscap scan
#
# $http_proxy_server:: hostname or IP address of http proxy server to use with --fetch-remote-resources.
#
# $http_proxy_port::   port of http proxy server to use with --fetch-remote-resources.
class foreman_scap_client(
  $server,
  $port,
  $policies,
  $ensure               = 'present',
  $ca_file              = $::foreman_scap_client::params::ca_file,
  $host_certificate     = $::foreman_scap_client::params::host_certificate,
  $host_private_key     = $::foreman_scap_client::params::host_private_key,
  $foreman_repo_rel     = undef,
  $foreman_repo_key     = 'https://yum.theforeman.org/RPM-GPG-KEY-foreman',
  $foreman_repo_src     = undef,
  $foreman_repo_gpg_chk = false,
  Boolean $fetch_remote_resources = false,
  Optional[String[1]]         $http_proxy_server = undef,
  Optional[Integer[0, 65535]] $http_proxy_port   = undef,
) inherits foreman_scap_client::params {

  if $http_proxy_server or $http_proxy_port {
    # If either of the 2 proxy parameters are set, they should both be set (not undef).
    assert_type(String[1], $http_proxy_server)
    assert_type(Integer[0, 65535], $http_proxy_port)
  }
  if $foreman_repo_rel {

    if $foreman_repo_key =~ /^http/ {
      $gpgkey = $foreman_repo_key
    } else {
      $gpgkey_file = '/etc/pki/rpm-gpg/RPM-GPG-KEY-foreman'
      $gpgkey = "file://${gpgkey_file}"

      file { $gpgkey_file:
        ensure => present,
        source => $foreman_repo_key,
        mode   => '0644',
        before => Yumrepo['foreman-plugins'],
      }
    }

    if $foreman_repo_src {
      $baseurl = $foreman_repo_src
    } else {
      $_osfamily = $::osfamily? {
        'Fedora' => 'f',
        default => 'el'
      }
      $baseurl = "http://yum.theforeman.org/plugins/${foreman_repo_rel}/${_osfamily}${::operatingsystemmajrelease}/\$basearch"
    }

    yumrepo { 'foreman-plugins':
      ensure   => present,
      descr    => "Foreman plugins ${foreman_repo_rel}",
      baseurl  => $baseurl,
      gpgkey   => $gpgkey,
      gpgcheck => $foreman_repo_gpg_chk,
      before   => Package['rubygem-foreman_scap_client']
    }
  }

  package { 'rubygem-foreman_scap_client': ensure => $ensure, } ->
  file { 'foreman_scap_client':
    ensure  => present,
    path    => '/etc/foreman_scap_client/config.yaml',
    content => template('foreman_scap_client/config.yaml.erb'),
    owner   => 'root',
  }

  file { 'foreman_scap_client_cron':
    ensure  => present,
    path    => '/etc/cron.d/foreman_scap_client_cron',
    content => template('foreman_scap_client/cron.erb'),
    owner   => 'root',
  }

  # Remove crons previously installed here
  exec { 'remove_foreman_scap_client_cron':
    command => "sed -i '/foreman_scap_client/d' /var/spool/cron/root",
    onlyif  => "grep -c 'foreman_scap_client' /var/spool/cron/root",
    path    => '/bin:/usr/bin',
  }
}
