#!/bin/bash

set -eo pipefail

# install vmware-fusion (currently 8.11.x)
brew cask install vmware-fusion

# install the vmware license
# https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1009244
echo "+++ Headless install of VMware license"
echo "$VMWARE_LICENSE_KEY" | sudo tee '/Applications/VMware Fusion.app/Contents/Library/License Key.txt'
sudo '/Applications/VMware Fusion.app/Contents/Library/Initialize VMware Fusion.tool' set "$BASHPID" '' "$VMWARE_LICENSE_KEY"

# Set up preferences to avoid first-run dialogs
# https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2008647
mkdir -vp "/Users/$USERNAME/Library/Preferences/VMware Fusion"
cp /private/tmp/vmware_prefs "/Users/$USERNAME/Library/Preferences/VMware Fusion/preferences"

# ensure that vmrun works
echo "+++ Sanity check that VMware is functional"
echo "Sanity check: $(vmrun list)"

# Install vagrant (currently 1.8.4)
brew cask install vagrant

# Install the VMware fusion plugin
vagrant plugin install vagrant-vmware-fusion

# Supply the license key for the Vagrant VMware plugin
vagrant plugin license vagrant-vmware-fusion /private/tmp/vmware-provider.license

# Add the box to the image for speed
vagrant box add --provider=vmware_fusion precise64 http://files.vagrantup.com/precise64_vmware.box
vagrant box list
