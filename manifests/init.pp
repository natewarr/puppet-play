# == Class: play
#
# Full description of class play here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class play (
  $owner = 'play',
  $group = 'play',
  $homepath = '/opt/play',
  $logback_file = 'puppet:///modules/play/logger-conf.xml',
  $logback_config = undef
) {

  group { $group:
    ensure     => present,
  }
  ->
  user { $owner:
    ensure => present,
    gid    => $group,
    shell  => '/bin/bash',
    home   => "/home/${owner}",
  }
  ->
  file { 'playappdir':
    ensure => 'directory',
    path   => $homepath,
    owner  => $owner,
    group  => $group,
    mode   => '0775',
  }
  file { 'apps':
    ensure  => 'directory',
    path    => "${homepath}/apps",
    owner   => $owner,
    group   => $group,
    require => File['playappdir'],
    mode    => '0775',
  }
  file { 'conf':
    ensure  => 'directory',
    path    => "${homepath}/conf",
    owner   => $owner,
    group   => $group,
    require => File['playappdir'],
    mode    => '0775',
  }
  file { 'logs':
    ensure  => 'directory',
    path    => "${homepath}/logs",
    owner   => $owner,
    group   => $group,
    require => File['playappdir'],
    mode    => '0775',
  }
  file { 'pids':
    ensure  => 'directory',
    path    => "${homepath}/pids",
    owner   => $owner,
    group   => $group,
    require => File['playappdir'],
    mode    => '0775',
  }
  file { [ "${homepath}/cache", "${homepath}/cache/zip"] :
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  case is_string($logback_config) {
    true:     { $set_logback_source = $logback_file }
    default:  { $set_logback_source = undef }
  }

  file { 'logback-conf':
    ensure  => 'file',
    path    => "${homepath}/conf/logger-conf.xml",
    owner   => $owner,
    group   => $group,
    require => File['conf'],
    mode    => '0775',
    source  => $set_logback_source,
    content => $logback_config,
  }

  if $::lsbdistid == 'ubuntu' {
    package {'unzip':
      ensure => installed,
    }~>
    exec {'apt-get update':
      command     => '/usr/bin/apt-get update',
      refreshonly => true,
    }
  }

}

