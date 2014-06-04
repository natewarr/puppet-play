class play::cleanup (
  $cacheHistory  =  0,
  $homePath      = '/opt/play'
) {

  $keepCurrent = $cacheHistory + 1

  exec { 'cleanup-cache-zips':
    command => "ls -t $homePath/cache/zip | head -n $cacheHistory|sort|uniq -u|xargs rm -f",
    cwd     => $homePath,
    path    => ['/bin','/usr/bin','/usr/local/bin'],
    user    => 'play',
  }

  exec { 'cleanup-cache-dirs':
    command => "ls -t $homePath/apps | head -n $keepCurrent|sort|uniq -u|xargs rm -rf",
    cwd     => $homePath,
    path    => ['/bin','/usr/bin','/usr/local/bin'],
    user    => 'play',
  }

}
