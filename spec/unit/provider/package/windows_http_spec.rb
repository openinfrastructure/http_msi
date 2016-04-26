# encoding: utf-8

require 'spec_helper'
require 'puppet/provider/package/windows'

describe 'Monkey Patch for PUP-3317' do
  describe '.install_command' do
    url = 'http://127.0.0.1:4000/data/7zip.msi'
    let(:type) { Puppet::Type.type(:package) }
    let :resource_hash do
      {
        name: '7zip.msi',
        ensure: 'installed',
        # dup is important here, the original string could be modified by Puppet (!!)
        source: url.dup,
        provider: :windows,
      }
    end
    let(:resource) { type.new(resource_hash) }
    let(:provider) { Puppet::Type.type(:package).provider(:windows).new(resource) }

    subject do
      installer = Puppet::Provider::Package::Windows::Package.installer_class(provider.resource)
      # The source is the last element of the installer command list
      installer.install_command(provider.resource).last
    end

    it 'does not replace slashes in source http urls' do
      expect(subject).to eq(url)
    end

    it 'sets FIXED_PUP_3317 to indicate the monkey patch' do
      expect(Puppet::Provider::Package::Windows::MsiPackage.const_defined? "FIXED_PUP_3317").to be_true
    end
  end
end
