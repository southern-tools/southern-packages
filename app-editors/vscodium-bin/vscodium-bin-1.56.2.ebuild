# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils xdg

MY_PN="${PN/-bin}"

DESCRIPTION="Free/Libre Open Source Software Binaries of VSCode"
HOMEPAGE="https://vscodium.com"
SRC_URI="
	amd64? (
		https://github.com/VSCodium/${MY_PN}/releases/download/${PV}/VSCodium-linux-x64-${PV}.tar.gz
	)
	arm? (
		https://github.com/VSCodium/${MY_PN}/releases/download/${PV}/VSCodium-linux-armhf-${PV}.tar.gz
	)
	arm64? (
		https://github.com/VSCodium/${MY_PN}/releases/download/${PV}/VSCodium-linux-arm64-${PV}.tar.gz
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64"
IUSE="libsecret"

RDEPEND="
	app-accessibility/at-spi2-atk
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/libpng:0/16
	net-print/cups
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/libnotify
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/pango
	libsecret? ( app-crypt/libsecret[crypt]	)
	amd64? ( sys-apps/ripgrep )
	arm64? ( sys-apps/ripgrep )
"

S="${WORKDIR}"

QA_PREBUILT="
	/opt/vscodium/chrome-sandbox
	/opt/vscodium/codium
	/opt/vscodium/libEGL.so
	/opt/vscodium/libGLESv2.so
	/opt/vscodium/libffmpeg.so
	/opt/vscodium/libvk_swiftshader.so
	/opt/vscodium/libvulkan.so
	/opt/vscodium/libvulkan.so.1
	/opt/vscodium/resources/app/extensions/node_modules/esbuild/bin/esbuild
	/opt/vscodium/resources/app/node_modules.asar.unpacked/*
	/opt/vscodium/swiftshader/*
	/opt/vscodium/swiftshader/libEGL.so
	/opt/vscodium/swiftshader/libGLESv2.so
"

src_prepare() {
	default

	# Remove libsecret (controlled via USE=libsecret)
	if ! use libsecret; then
		rm -r "resources/app/node_modules.asar.unpacked/keytar" || die
	fi

	# Unbundle ripgrep on amd64 & arm64
	if use amd64 || use arm64; then
		rm "resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg" || die
	fi
}

src_install() {
	pax-mark m codium
	insinto "/opt/${MY_PN}"
	doins -r *
	dosym "../../opt/${MY_PN}/bin/codium" "usr/bin/codium"

	domenu "${FILESDIR}/codium.desktop"
	domenu "${FILESDIR}/codium-url-handler.desktop"

	fperms +x /opt/${MY_PN}/{,bin/}codium
	fperms +x /opt/${MY_PN}/chrome-sandbox
	fperms -R +x /opt/${MY_PN}/resources/app/out/vs/base/node

	if use amd64 || use arm64; then
		dosym "../../../../../../../usr/bin/rg" "${EPREFIX}/opt/${MY_PN}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"
	else
		# On other arches we don't unbundle rg, so we have to make it executable
		fperms +x /opt/${MY_PN}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg
	fi

	dodoc resources/app/LICENSE.txt resources/app/ThirdPartyNotices.txt
	newicon resources/app/resources/linux/code.png ${MY_PN}.png
}
