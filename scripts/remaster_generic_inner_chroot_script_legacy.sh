#!/bin/sh

/usr/sbin/env-update
. /etc/profile


# make sure there is no stale pid file around that prevents entropy from running
rm -f /var/run/entropy/entropy.lock

LOC=$(pwd)
EREPO=/etc/entropy/repositories.conf.d
cd "$EREPO"
wget http://pkg.rogentos.ro/~rogentos/distro/entropy_rogentoslinux
wget http://pkg.rogentos.ro/~rogentos/distro/entropy_rogentos-legacy
equo repo mirrorsort rogentoslinux
equo repo mirrorsort kogaionlinux.ro
if [ -f "/etc/entropy/repositories.conf.d/entropy_kogaionlinux.ro.example" ]; then
	mv "${EREPO}/entropy_kogaionlinux.ro.example" "${EREPO}/entropy_kogaionlinux.ro"
fi
if [ -f "${EREPO}/entropy_kogaion-weekly" ]; then
	mv "${EREPO}/entropy_kogaion-weekly" "${EREPO}/entropy_kogaion-weekly.example"
fi
cd $LOC

export FORCE_EAPI=2

updated=0
for ((i=0; i < 6; i++)); do
		equo update && {
				updated=1;
				break;
		}
		sleep 1200 || exit 1
done

if [ "${updated}" = "0" ]; then
		exit 1
fi

# disable all mirrors but GARR
for repo_conf in /etc/entropy/repositories.conf /etc/entropy/repositories.conf.d/entropy_sab*; do
	# skip .example files
	if [[ "${repo_conf}" =~ .*\.example$ ]]; then
		echo "skipping ${repo_conf}"
		continue
	fi
	sed -n -e "/pkg.sabayon.org/p" -e "/garr.it/p" -e "/^branch/p" \
		-e "/^product/p" -e "/^official-repository-id/p" -e "/^differential-update/p" \
		-i "${repo_conf}"
done

equo mask sabayon-skel sabayon-version sabayon-artwork-grub
equo remove sabayon-artwork-grub sabayon-artwork-core sabayon-artwork-isolinux sabayon-version sabayon-skel kogaion-live grub --nodeps
emerge -C sabayon-version
equo mask sabayon-version openrc@kogaionlinux.ro openrc@sabayon-limbo openrc@kogaion-weekly
equo mask grub@kogaion-weekly grub@kogaionlinux.ro grub@sabayon-limbo

echo ">=sys-apps/openrc-0.9@sabayon-limbo
>=sys-apps/openrc-0.9@kogaionlinux.ro
>=sys-apps/openrc-0.9@kogaion-weekly

>=sys-boot/grub-2.00@sabayon-limbo
>=sys-boot/grub-2.00@sabayonlinux.rg
>=sys-boot/grub-2.00@kogaion-weekly

>=app-misc/sabayon-version-1@kogaionlinux.ro
>=app-misc/sabayon-version-1@kogaion-weekly
>=app-misc/sabayon-version-1@sabayon-limbo

>=app-misc/sabayon-skel-1@kogaionlinux.ro
>=app-misc/sabayon-skel-1@kogaion-weekly
>=app-misc/sabayon-skel-1@sabayon-limbo

>=app-misc/kogaion-live-1@kogaionlinux.ro
>=app-misc/kogaion-live-1@kogaion-weekly
>=app-misc/kogaion-live-1@sabayon-limbo

>=x11-themes/sabayon-artwork-core-1@kogaionlinux.ro
>=x11-themes/sabayon-artwork-core-1@kogaion-weekly
>=x11-themes/sabayon-artwork-core-1@sabayon-limbo

>=x11-themes/sabayon-artwork-lxde-1@kogaionlinux.ro
>=x11-themes/sabayon-artwork-lxde-1@kogaion-weekly
>=x11-themes/sabayon-artwork-lxde-1@sabayon-limbo

>=x11-themes/sabayon-artwork-kde-1@kogaionlinux.ro
>=x11-themes/sabayon-artwork-kde-1@kogaion-weekly
>=x11-themes/sabayon-artwork-kde-1@sabayon-limbo

>=x11-themes/sabayon-artwork-isolinux-1@kogaionlinux.ro
>=x11-themes/sabayon-artwork-isolinux-1@kogaion-weekly
>=x11-themes/sabayon-artwork-isolinux-1@sabayon-limbo

>=x11-themes/sabayon-artwork-grub-1@kogaionlinux.ro
>=x11-themes/sabayon-artwork-grub-1@kogaion-weekly
>=x11-themes/sabayon-artwork-grub-1@sabayon-limbo

>=x11-themes/sabayon-artwork-gnome-1@kogaionlinux.ro
>=x11-themes/sabayon-artwork-gnome-1@kogaion-weekly
>=x11-themes/sabayon-artwork-gnome-1@sabayon-limbo

>=x11-themes/sabayon-artwork-extra-1@kogaionlinux.ro
>=x11-themes/sabayon-artwork-extra-1@kogaion-weekly
>=x11-themes/sabayon-artwork-extra-1@sabayon-limbo

>=kde-base/oxygen-icons-4.9.0@kogaion-weekly
>=kde-base/oxygen-icons-4.9.1@kogaionlinux.ro
>=kde-base/oxygen-icons-4.9.2@sabayon-limbo

>=x11-themes/gnome-colors-common-5.5.1@kogaion-weekly
>=x11-themes/gnome-colors-common-5.5.1@kogaionlinux.ro
>=x11-themes/gnome-colors-common-5.5.1@sabayon-limbo

>=x11-themes/tango-icon-theme-0.8.90@kogaion-weekly
>=x11-themes/tango-icon-theme-0.8.90@kogaionlinux.ro
>=x11-themes/tango-icon-theme-0.8.90@sabayon-limbo

>=x11-themes/elementary-icon-theme-2.7.1@kogaion-weekly
>=x11-themes/elementary-icon-theme-2.7.1@kogaionlinux.ro
>=x11-themes/elementary-icon-theme-2.7.1@sabayon-limbo

>=sys-apps/gpu-detector-1@kogaion-weekly
>=sys-apps/gpu-detector-1@kogaionlinux.ro
>=sys-apps/gpu-detector-1@sabayon-limbo

>=lxde-base/lxdm-0.4.1-r5@kogaion-weekly
>=lxde-base/lxdm-0.4.1-r5@kogaionlinux.ro
>=lxde-base/lxdm-0.4.1-r5@sabayon-limbo

>=x11-base/xorg-server-1.11@kogaion-weekly
>=x11-base/xorg-server-1.11@kogaionlinux.ro
>=x11-base/xorg-server-1.11@sabayon-limbo

>=app-admin/anaconda-0.1@kogaion-weekly
>=app-admin/anaconda-0.1@kogaionlinux.ro
>=app-admin/anaconda-0.1@sabayon-limbo

>=app-misc/anaconda-runtime-1.1-r1@kogaion-weekly
>=app-misc/anaconda-runtime-1.1-r1@kogaionlinux.ro
>=app-misc/anaconda-runtime-1.1-r1@sabayon-limbo" >> /etc/entropy/packages/package.mask

