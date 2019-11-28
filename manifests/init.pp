# @summary Configures foreman_scap_client and sets cron tasks to run it
#
# @param ensure
#   Passed to the rubygem-foreman_scap_client package.
#
# @param install_options
#   Passed to the rubygem-foreman_scap_client package.
#
# @param server
#   foreman proxy url where arf reports should be sent
#
# @param port
#   port of foreman proxy that is used as $server
#
# @param ca_file
#   path to file of certification authority that issued client's certificate
#   May be overriden if $::rh_certificate_repo_ca_file (from Facter) is found
#
# @param host_certificate
#   path to host certificate, usually puppet agent certificate
#   May be overriden if $::rh_certificate_consumer_host_cert (from Facter) is found
#
# @param host_private_key
#   path to host private key, usually puppet agent private key
#   May be overriden if $::rh_certificate_consumer_host_key (from Facter) is found
#
# @param package_name
#   os dependent package name for rubygem-foreman_scap_client package
#
# @param foreman_repo_rel
#   add / manage foreman-plugins yum repo and set to release version. Eg  '1.14'
#
# @param foreman_repo_key
#   RPM Key source file for foreman-plugins repo. Note: Currently, packages are not signed.
#   Unless set to an alternative file source, URL will be used.
#
# @param foreman_repo_src
#   Alternative baseurl for The Foreman plugins repository
#
# @param foreman_repo_gpg_chk
#   Enable / disable GPG checks. Directly passed to Yumrepo resource
#
# @param policies
#   Array of policies that should be configured, each member represent
#   one policy in form of hash
#   Policy hash must have following structure
#
#   { "id" => 1, "hour" => "*", "minute" => "*", "month" => "*",
#     "monthday" => "*", "weekday" => "*", "profile_id" => '',
#     "content_path" => '/usr/share/...',
#     "tailoring_path" => '/var/lib...'
#   }
#
#   note that profile_id may be empty (for default profile)
#   id is number representing id of policy in foreman
#   content_path is path to DS file that contains profile
#
#   if it's not array, it's automatically converted to it, so you can
#   even specify just one policy as a hash
#
# @param cron_template
#   Path to cron template
#
# @param cron_splay
#   Upper limit for splay time when sending reports to proxy
#
# @param http_proxy_server
#   HTTP proxy server
#
# @param http_proxy_port
#   HTTP proxy port
#
# @param fetch_remote_resources
#   Whether client should fetch referenced resources that are remote
#
# @param timeout
#   Timeout when sending reports to proxy
#
# @example Run a weekly SCAP audit
#   class { foreman_scap_client:
#     server           => 'proxy.example.com',
#     port             => '8443',
#     foreman_repo_rel => '1.24',
#     policies         => [{
#       "id"                      => 1,
#       "hour"                    => "12",
#       "minute"                  => "1",
#       "month"                   => "*",
#       "monthday"                => "*",
#       "weekday"                 => "1",
#       "profile_id"              => '',
#       "content_path"            => '/usr/share/xml/scap/ssg/fedora/ssg-fedora-ds.xml',
#       "download_path"           => '/compliance/policies/1/content',
#       "tailoring_path"          => '/var/lib/openacap/ssg-fedora-ds-tailored.xml',
#       "tailoring_download_path" => "/compliance/policies/1/tailoring"
#     }]
#   }
class foreman_scap_client(
  Stdlib::Host $server,
  Stdlib::Port $port,
  Array $policies,
  String $ensure = 'present',
  Boolean $fetch_remote_resources = false,
  Optional[Stdlib::Host] $http_proxy_server = undef,
  Optional[Stdlib::Port] $http_proxy_port = undef,
  Stdlib::Absolutepath $ca_file = $::foreman_scap_client::params::ca_file,
  Stdlib::Absolutepath $host_certificate = $::foreman_scap_client::params::host_certificate,
  Stdlib::Absolutepath $host_private_key = $::foreman_scap_client::params::host_private_key,
  String $package_name = $::foreman_scap_client::params::package_name,
  Optional[String] $foreman_repo_rel = undef,
  String $foreman_repo_key = 'https://yum.theforeman.org/RPM-GPG-KEY-foreman',
  Optional[String] $foreman_repo_src = undef,
  Boolean $foreman_repo_gpg_chk = false,
  Optional[String] $install_options = undef,
  String $cron_template = 'foreman_scap_client/cron.erb',
  Integer[0] $cron_splay = 600,
  Integer[0] $timeout = 60,
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

    if versioncmp($foreman_repo_rel, '1.20') >= 0 {
      $_reposuffix = 'client'
    } else {
      $_reposuffix = 'plugins'
    }

    if $foreman_repo_src {
      $baseurl = $foreman_repo_src
    } else {
      $_osfamily = $::osfamily? {
        'Fedora' => 'f',
        default => 'el'
      }
      $baseurl = "https://yum.theforeman.org/${_reposuffix}/${foreman_repo_rel}/${_osfamily}${::operatingsystemmajrelease}/\$basearch"
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
