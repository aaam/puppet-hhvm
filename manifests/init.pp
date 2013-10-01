class hhvm() {
  validate_re($::osfamily, '^Debian$', 'This module uses the docker apt repo and only works on Debian systems that support it.')

  include apt

  apt::source { 'hhvm':
    location          => 'http://dl.hiphop-php.com/ubuntu',
    release           => 'precise',
    repos             => 'main',
    required_packages => 'debian-keyring debian-archive-keyring',
    include_src       => false,
  }

  apt::source { 'hhvm_universe':
    location          => 'http://archive.ubuntu.com/ubuntu',
    release           => 'precise',
    repos             => 'main universe',
    required_packages => 'debian-keyring debian-archive-keyring',
    include_src       => false,
  }

  file { '/etc/apt/apt.conf.d/hhvm':
    owner     => root,
    group     => root,
    content   => "APT::Get::AllowUnauthenticated yes;",
    mode      => 644;
  }

  package { 'hiphop-php':
    ensure  => 'present',
    require => [ Apt::Source['hhvm'], Apt::Source['hhvm_universe'], File['/etc/apt/apt.conf.d/hhvm'] ],
  }
}
