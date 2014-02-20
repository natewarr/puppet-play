define play::application(
  $source,
  $path = "/opt/play/apps/$title",
  $ensure  = 'running',
  $service = 'yes',
  $autostart = 'yes',
  $javaOptions = '',
)
{
  require play

  #download the application from $source
  archive {"play-application-$title":
    ensure   => 'present',
    url      => $source,
    target   => $path,
    owner    => 'play',
    group    => 'play',
  }

}
