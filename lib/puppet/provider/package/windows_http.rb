require 'uri'

# This is really defensive code in the event Puppet changes and the monkey
# patching would be broken.  The idea is to continue working, just warn once
# that the fix has not been put into place.
msg = "fix for installing MSI packages via HTTP (PUP-3317) has been disabled"
begin
  require 'puppet/provider/package/windows/msi_package'
rescue LoadError
  Puppet.warn_once "Could not load msi_package.rb, #{msg} "
else
  klass_name = "Puppet::Provider::Package::Windows::MsiPackage"
  if not Module.const_defined?(klass_name)
    Puppet.warn_once "#{klass_name} does not exist, #{msg}"
  else
    class Puppet::Provider::Package::Windows
      class MsiPackage
        unless self.const_defined?('FIXED_PUP_3317')
          FIXED_PUP_3317 = true
          Puppet.debug "JJM HOTFIX: A97E77AE-5199-4D6E-937A-74849C2DB542"
          Puppet.debug "Monkey patching windows package provider to support HTTP source URLs"
          Puppet.debug "Remove this module once PUP-3317 has been resolved"
          def self.replace_forward_slashes(value)
            if URI.regexp.match(value)
              Puppet.debug('Package source parameter is a URL, not modifying (PUP-3317)')
              newvalue = value
            else
              Puppet.debug('Package source parameter contained /s - replaced with \\s')
              newvalue = value.gsub('/', "\\")
            end
            newvalue
          end
        end
      end
    end
  end
end
