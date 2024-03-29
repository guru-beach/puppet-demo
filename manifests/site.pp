node default {
  # Defining variables used here, could be in hiera, but this is a pretty simple config
  $www_user           = 'www'
  $www_group          = 'www'
  $www_id             = '1000'
  $www_root           = '/var/www'
  $challenge_name     = 'challenge'
  $challenge_root     = "${www_root}/${challenge_name}"
  $challenge_checkout = 'https://github.com/puppetlabs/exercise-webpage'
  $challenge_port     = '8000'
 
  #User and group probably aren't necessary, but it's not necessarily a bad idea
  group { "${www_group}":
    ensure => present,
    gid    => "${www_id}",
  }

  user { "${www_user}":
    ensure     => present,
    require    => Group["${www_group}"],
    managehome => true,
    home       => '/var/www',
    uid        => "${www_id}",
    gid        => "${www_id}",
    shell      => '/sbin/nologin',
  }

  file { '/var/www':
    ensure  => directory,
    owner   => "${www_user}",
    group   => "${www_group}",
    mode    => 0755,
    require => User["${www_user}"]
  }
  
  #Plan for more than one site
  vcsrepo { "${challenge_root}" :
    ensure   => latest,
    provider => git,
    source   => "${challenge_checkout}",
    user     => root,
    owner    => "${www_user}",
    group    => "${www_group}",
    require => User["${www_user}"],
  }

  include nginx
  nginx::resource::vhost { "${challenge_name}":
    ensure      => present,
    www_root    => "${challenge_root}",
    listen_port => "${challenge_port}",
    require     => Vcsrepo["${challenge_root}"],
  }
}
