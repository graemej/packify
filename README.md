#packify

Standalone testcase to reproduce a problem with `vagrant` + `vmware` provider.

## prereqs
* check out submodules after cloning
* have `packer` installed: `brew install packer`
* download [OS X installer from the App Store](http://osxdaily.com/2014/12/30/re-download-os-x-mavericks-installer-from-os-x-yosemite-app-store/)
* create a `packer-vars.json` file in your home directory that contains the following info:

```
{
  "vmware_license_key": "license-key-goes-here",
  "vmware_provider_license": "path/to/license/file"
}
```

## building
A makefile contains the logic to drive the various build steps
### `make iso`: run this (once) first
 * converts the installer dmg into an ISO file needed by subsequent build steps
   * input: `/Applications/Install OS X El Capitan.app/`
   * output: `packer_cache/OSX_InstallESD_10.11.6_15G31.dmg`
 * ETA: ~10 minutes

### `make base` : run this (once) next
* installs OSX and the Xcode CLI tools and produces a .vmx file
  * input: `packer_cache/OSX_InstallESD_10.11.6_15G31.dmg`
  * output: `output-vmware-iso/packer-vmware-iso.vmx`
* ETA: ~15 minutes

### `make final` : iterate here
* creates a `vagrant` box based on the base vmx and installs homebrew, vmware, vagrant, vmware-provider
  * input: `output-vmware-iso/packer-vmware-iso.vmx`
  * output: `packer_vmware-vmx_vmware.box`
* ETA: ~5 minutes

### `make test` : iterate here
* launches the `vagrant` box and then spins up `vagrant` inside the VM after doing some environment sanity checks
  * input: `packer_vmware-vmx_vmware.box`
  * output: `none`
* ETA: ~5 minutes
