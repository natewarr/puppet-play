define play::application(
  $source,
  $ensure       = 'installed',
  $version      = '1.0',
  $app_name     = $title,
  $port         = '9000',
  $path         = '/opt/play',
  $service      = true,
  $enable       = true,
  $exec_params  = '',
  $config_file  = 'puppet:///modules/play/play-default.conf',
  $service_name = "play-${title}",
)
{
  Exec { user => 'play'}

  require play
  case $ensure {
    'installed' : {

      #download the application from $source
      wget::fetch { $source:
        destination => "${path}/cache/zip/${app_name}-${version}.zip",
      } ->

      #extract application archive
      exec {"extract ${source}":
        command => "/usr/bin/unzip ${path}/cache/zip/${app_name}-${version}.zip -d ${path}/apps",
        path    => "${path}/apps",
        creates => "${path}/apps/${app_name}-${version}",
      } ->

      file {"${path}/apps/${app_name}-${version}" :
        ensure => 'directory',
      }

      file {"${path}/conf/${service_name}.conf":
        ensure => 'file',
        source => $config_file,
        owner  => 'play',
        group  => 'play',
        mode   => '0600',
      }

      file {"${path}/logs/${service_name}" :
        ensure => directory,
        owner  => 'play',
        group  => 'play',
        mode   => '0755',
      }

      if ( $service == true ) {
        file {"/etc/init.d/${service_name}":
          ensure  => 'file',
          content => template('play/initd-play-app.erb'),
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          require => File["${path}/apps/${app_name}-${version}",
                          "${path}/conf/${service_name}.conf",
                          "${path}/logs/${service_name}" ],
          notify => Service[$service_name],
        }

        service { $service_name :
          ensure     => 'running',
          enable     => $enable,
          hasstatus  => true,
          hasrestart => true,
          require    => File["/etc/init.d/${service_name}"],
        }
      }
    }
    'absent': {
      service {"play-${service_name}":
        ensure => stopped,
      } ->
      file {"${path}/apps/${app_name}-${version}":
        ensure => absent,
      } ->
      file {"/etc/init.d/${service_name}":
        ensure => absent,
      }
    }
    default: { err ( "Unknown ensure value: '${ensure}'" ) }
  }
}
