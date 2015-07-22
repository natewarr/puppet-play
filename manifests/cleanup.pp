class play::cleanup (
  $cacheHistory  =  2,
  $homePath      = '/opt/play'
) {

  $keepCurrent = $cacheHistory + 1

  exec { 'cleanup-cache-zips':
    command => "ls -tr . | head -n $(expr $(ls . | wc -l) - ${keepCurrent}) | xargs rm -f",
    cwd     => "${homePath}/cache/zip",
    path    => ['/bin','/usr/bin','/usr/local/bin'],
    user    => 'play',
  }

  exec { 'cleanup-cache-dirs':
    command => "ls -tr . | head -n $(expr $(ls . | wc -l) - ${keepCurrent}) | xargs rm -rf",
    cwd     => "${homePath}/apps",
    path    => ['/bin','/usr/bin','/usr/local/bin'],
    user    => 'play',
  }

}
