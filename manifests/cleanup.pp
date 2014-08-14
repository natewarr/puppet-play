class play::cleanup (
  $cacheHistory  =  0,
  $homePath      = '/opt/play'
) {

  $keepCurrent = $cacheHistory + 1

  exec { 'cleanup-cache-zips':
    command => "count=`ls . | wc -l`; delete=`expr ${count} - ${keepCurrent}`; ls -tr . | head -n ${delete} | xargs rm -f",
    cwd     => "${homePath}/cache/zip",
    path    => ['/bin','/usr/bin','/usr/local/bin'],
    user    => 'play',
  }

  exec { 'cleanup-cache-dirs':
    command => "count=`ls . | wc -l`; delete=`expr ${count} - ${keepCurrent}`; ls -tr . | head -n ${delete} | xargs rm -rf",
    cwd     => "$homePath/apps",
    path    => ['/bin','/usr/bin','/usr/local/bin'],
    user    => 'play',
  }

}
