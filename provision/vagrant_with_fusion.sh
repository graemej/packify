#!/bin/bash

set -eo pipefail

if [ "${INCLUDE_VAGRANT}" != 'true' ]; then
  echo "Skipping Vagrant install."
  exit 0
fi

# install vmware-fusion (currently 8.11.x)
brew cask install vmware-fusion

# install the vmware license
# https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1009244
echo "+++ Headless install of VMware license"
sudo cp -v /private/tmp/VMwareKey.txt '/Applications/VMware Fusion.app/Contents/Library/License Key.txt'
sudo '/Applications/VMware Fusion.app/Contents/Library/Initialize VMware Fusion.tool' set "$BASHPID" '' "$VMWARE_LICENSE_KEY"

# Set up preferences to avoid first-run dialogs
# https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2008647
mkdir -vp '/Users/shopify/Library/Preferences/VMware Fusion'
cp /private/tmp/vmware_prefs '/Users/shopify/Library/Preferences/VMware Fusion/preferences'

# ensure that vmrun works
echo "+++ Sanity check that VMware is functional"
echo "Sanity check: $(vmrun list)"

# Install vagrant (currently 1.8.4)
brew cask install vagrant

# Make a temporary file to contain the sudoers-changes to be pre-checked
TMP=$(mktemp -t vagrant_sudoers)
sudo cat /etc/sudoers > $TMP
cat >> $TMP <<EOF

# Allow passwordless startup of Vagrant when using NFS.
Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/su root -c echo '*' >> /etc/exports
Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
%staff ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE
EOF

# Check if the changes we want are OK
sudo visudo -c -f $TMP
if [ $? -eq 0 ]; then
  echo "Adding vagrant commands to sudoers"
  sudo cp -v $TMP /etc/sudoers
else
  echo "sudoers syntax wasn't valid. Aborting!"
fi

# Install the VMware fusion plugin
vagrant plugin install vagrant-vmware-fusion

# Supply the license key for the Vagrant VMware plugin
vagrant plugin license vagrant-vmware-fusion /private/tmp/vmware.lic


