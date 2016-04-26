# Puppet HTTP MSI Fix

This module provides a fix for
[PUP-3317](https://tickets.puppetlabs.com/browse/PUP-3317).  Install this module
into your control repository, or however you manage modules, and then use plugin
sync to get the code to all of your agents.

This module does one thing only, and that is monkey-patches the Windows MSI package
provider so that source parameters do *not* have their value munged if they're a
valid URI string.  This allows the following to work on windows.

    package { '7zip':
      ensure => installed,
      source => 'http://127.0.0.1:8000/packages/7zip.msi',
    }

# Author

Jeff McCune of [Open Infrastructure Services](https://www.openinfrastructure.co)
