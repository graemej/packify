# use 'make box' to populate the packer cache

ADMIN_USER=root
ADMIN_PASS=root
DMG=packer_cache/OSX_InstallESD_10.11.6_15G31.dmg
VMX=packer_cache/

# use 'make iso' to populate the packer_cache
.PHONY: iso
iso: $(DMG)

$(DMG):
	sudo ./osx-vm-templates/prepare_iso/prepare_iso.sh \
	'/Applications/Install OS X El Capitan.app/' \
	./packer_cache

clean:
	rm -f $(DMG)

base:
	packer build $(PACKER_OPTIONS) \
	  -var iso_url=$(realpath $(DMG)) \
	  -var install_vagrant_keys=false \
	  -var iso_checksum=none \
	  -only=vmware-iso \
	  base.json
