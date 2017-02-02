## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Disable filebucket by default for all File resources:
File { backup => false }

# Randomize enforcement order to help understand relationships
ini_setting { 'random ordering':
  ensure  => present,
  path    => "${settings::confdir}/puppet.conf",
  section => 'agent',
  setting => 'ordering',
  value   => 'title-hash',
}

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  #i have done few thing done know what i am doing here
  # Example:
  #   class { 'my_class': }
  include role::classroom
  
 # file { '/etc/motd':
 # ensure  => file,
 # owner   => 'root',
 # group   => 'root',
 # mode    => '0644',
 # content => "thi is kash",
 
include users
include skeleton
include memcached
include nginx

# Use $pe_server_version if set, otherwise fall back to $pe_version
$version = pick($::pe_server_version, $::pe_version)
# if $version is older than 2015.2 then fail compilation with a warning
if versioncmp($version, '2016.1.0') < 0 {
fail("This Training VM is out of date. Please update: ${download_url}")
}

}
