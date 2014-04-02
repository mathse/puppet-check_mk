class check_mk (
  $filestore   = undef,
  $host_groups = undef,
  $package     = 'omd-0.56',
  $site        = 'monitoring',
  $workspace   = '/root/check_mk',
  $listen_ip   = undef,
  $listen_port = undef,
) {
  class { 'check_mk::install':
    filestore => $filestore,
    package   => $package,
    site      => $site,
    workspace => $workspace,
  }
  class { 'check_mk::config':
    host_groups => $host_groups,
    site        => $site,
    require     => Class['check_mk::install'],
  }
  class { 'check_mk::service':
    require   => Class['check_mk::config'],
  }
  if $listen_ip {
	exec { 'set-listen-port': 
		command => "/bin/sed -i 's/127\.0\.0\.1\:[0-9]\+/${listen_ip}:${$listen_port}/g' /omd/sites/${site}/etc/apache/listen-port.conf",
		onlyif  => '/usr/bin/test -n "`grep 7.0.0 /omd/sites/prod/etc/apache/listen-port.conf`"',
		notify  => Service['omd'],
	}
  }
}
