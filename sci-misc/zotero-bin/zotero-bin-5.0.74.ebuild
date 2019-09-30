# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop gnome2-utils

MY_PN="Zotero"
LNXARCH="linux-x86_64"

DESCRIPTION="A free, easy-to-use tool to help you collect, organize, cite, and share research"
HOMEPAGE="https://www.zotero.org/"
SRC_URI="https://www.zotero.org/download/client/dl?channel=release&platform=${LNXARCH}&version=${PV} -> ${MY_PN}-${PV}_${LNXARCH}.tar.bz"

MY_P="${MY_PN}-${PV}"

S="${WORKDIR}/${MY_PN}_${LNXARCH}"

IUSE=""
LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

ZOTERO_INSTALL_DIR="/opt/${PN}"

QA_PRESTRIPPED="opt/${PN}/lib.*\.so
opt/${PN}/gtk2/libmozgtk.so
opt/${PN}/gmp-clearkey/0.1/libclearkey.so
opt/${PN}/updater
opt/${PN}/minidump-analyzer
opt/${PN}/plugin-container
opt/${PN}/zotero-bin
"

src_install() {
	# install zotero files to /opt/zotero
	dodir ${ZOTERO_INSTALL_DIR}
	cp -a "${S}"/. "${D}${ZOTERO_INSTALL_DIR}" || die "Installing files failed"

	# install zotero-start.sh in /opt/zotero
	touch "$D${ZOTERO_INSTALL_DIR}/zotero-start.sh"

	# give it some instructions to start zotero
	echo "#!/bin/sh" >> $D${ZOTERO_INSTALL_DIR}/zotero-start.sh
	echo "exec \"/opt/${PN}/zotero\"" >>  $D${ZOTERO_INSTALL_DIR}/zotero-start.sh

	# make zotero-start.sh executable
	fperms +x ${ZOTERO_INSTALL_DIR}/zotero-start.sh

	# sym link /opt/zotero/zotero-start.sh to /opt/bin/zotero
	dosym ${ZOTERO_INSTALL_DIR}/zotero-start.sh /opt/bin/zotero

	newicon -s 48 chrome/icons/default/default48.png zotero.png
	newicon chrome/icons/default/default48.png zotero.png
	newicon -s 32 chrome/icons/default/default32.png zotero.png
	newicon -s 16 chrome/icons/default/default16.png zotero.png
	make_desktop_entry "/opt/bin/zotero" Zotero zotero Science
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
