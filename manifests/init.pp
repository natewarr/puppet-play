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
  $owner = "play",
  $group = "play",
  $homepath = "/opt/play"
) {

  group { "${group}":
    ensure     => present,
  }
  ->
  user { "${owner}":
    ensure     => present,
    gid        => "${group}",
    shell      => '/bin/bash',
    home       => "/home/${owner}",
  }
  ->
  file { "playappdir":
    path     => "${homepath}",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    mode     => 0550,
  }
  file { "play-apps":
    path     => "${homepath}/play-apps",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['playappdir'],
    mode     => 0550,
  }
  file { "play-conf":
    path     => "${homepath}/play-conf",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['playappdir'],
    mode     => 0550,
  }
  file { "play-logs":
    path     => "${homepath}/play-logs",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['playappdir'],
    mode     => 0770,
  }
  file { "play-pids":
    path     => "${homepath}/play-pids",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['playappdir'],
    mode     => 0770,
  }

  file { "play-logback-conf":
    path     => "${homepath}/play-conf/logger-conf.xml",
    ensure   => "file",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['play-conf'],
    mode     => 0550,
    source   => "puppet:///modules/play/logger-conf.xml",
  }
}
