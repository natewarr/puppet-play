puppet-play
=========
puppet-play is a puppet component module to deploy play-framework applications on Linux
  - deploys one or more applications on a node via the *play::application* type
  - downloads the bundled zip file containing the application(s) and builds a service from each application
  - updates applications when the version string changes
  - cleans up historical builds when the *play::cleanup* class is included
  - works on Ubuntu and CentOS

Requires
-------------
- JVM (This is up to you. The module assumes the JVM is installed)
- [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
- [maestrodev/wget](https://forge.puppetlabs.com/maestrodev/wget)
 
Installation
--------------

```puppet
include play
play::application { 'helloworld' :
  source => 'http://10.0.0.1/binaryrepo/helloworld.zip',
  port => '9000',
}
```

Hacking
----
Please send updates to this module as needed. A few things that are outstanding:
- puppet-rspec
- better doc

