# Configures foreman_scap_client and sets cron tasks to run it
#
# === Parameters:
#
# $ensure::           Passed to the rubygem-foreman_scap_client package.
#                     Default: present
#
# $install_options::  Passed to the rubygem-foreman_scap_client package.
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
# $package_name ::    os dependent package name for rubygem-foreman_scap_client package
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
#
# $cron_template::    Path to cron template
#
# $cron_splay::       Upper limit for splay time when sending reports to proxy
#
# $http_proxy_server:: HTTP proxy server
#
# $http_proxy_port::  HTTP proxy port
#
# $fetch_remote_resources:: Whether client should fetch referenced resources that are remote
#
# $timeout:: Timeout when sending reports to proxy
#
class foreman_scap_client(
  $server,
  $port,
  $policies,
  $ensure                 = 'present',
  $fetch_remote_resources = false,
  $http_proxy_server      = undef,
  $http_proxy_port        = undef,
  $ca_file                = $::foreman_scap_client::params::ca_file,
  $host_certificate       = $::foreman_scap_client::params::host_certificate,
  $host_private_key       = $::foreman_scap_client::params::host_private_key,
  $package_name           = $::foreman_scap_client::params::package_name,
  $foreman_repo_rel       = undef,
  $foreman_repo_key       = 'https://yum.theforeman.org/RPM-GPG-KEY-foreman',
  $foreman_repo_src       = undef,
  $foreman_repo_gpg_chk   = false,
  $install_options        = undef,
  $cron_template          = 'foreman_scap_client/cron.erb',
  $cron_splay             = 600,
  $timeout                = 60,
) inherits foreman_scap_client::params {
  $cron_sleep = fqdn_rand($cron_splay)

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
      $baseurl = "http://yum.theforeman.org/client/${foreman_repo_rel}/${_osfamily}${::operatingsystemmajrelease}/\$basearch"
    }

    if versioncmp($foreman_repo_rel, '1.20') >= 0 {
      $_reposuffix = 'client'
    } else {
      $_reposuffix = 'plugins'
    }

    yumrepo { "foreman-${_reposuffix}":
      ensure   => present,
      descr    => "Foreman ${_reposuffix} ${foreman_repo_rel}",
      baseurl  => $baseurl,
      gpgkey   => $gpgkey,
      gpgcheck => $foreman_repo_gpg_chk,
      before   => Package[$package_name]
    }
  }

  package { $package_name:
    ensure          => $ensure,
    install_options => $install_options,
  }
  -> file { '/etc/foreman_scap_client':
    ensure => directory,
    owner  => 'root',
  }

  file { 'foreman_scap_client':
    ensure  => present,
    path    => '/etc/foreman_scap_client/config.yaml',
    content => template('foreman_scap_client/config.yaml.erb'),
    owner   => 'root',
  }

  file { 'foreman_scap_client_cron':
    ensure  => present,
    path    => '/etc/cron.d/foreman_scap_client_cron',
    content => template($cron_template),
    owner   => 'root',
  }

  # Remove crons previously installed here
  exec { 'remove_foreman_scap_client_cron':
    command => "sed -i '/foreman_scap_client/d' /var/spool/cron/root",
    onlyif  => "grep -c 'foreman_scap_client' /var/spool/cron/root",
    path    => '/bin:/usr/bin',
  }
}
