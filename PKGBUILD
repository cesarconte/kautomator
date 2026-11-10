# Maintainer: Cesar <yugurta@gmail.com>
# Contributor: CachyOS Linux Architect Team

pkgname=kautomator
pkgver=1.0.0
pkgrel=1
pkgdesc="Hazel-style Smart Folder Rules and file automation daemon for KDE Plasma 6 and Dolphin"
arch=('any')
url="https://github.com/cesarconte/kautomator"
license=('GPL-3.0-or-later')
depends=(
    'python'
    'libnotify'
    'glib2'
)
optdepends=(
    'kunpack: Auto-unpack archives on download'
    'ktags: Automatically tag organized files with macOS Finder colors'
    'dolphin: Context menu integration for directories'
)
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/cesarconte/${pkgname}/archive/v${pkgver}.tar.gz")
sha256sums=('SKIP')

package() {
    cd "${srcdir}/${pkgname}-${pkgver}" 2>/dev/null || cd "${srcdir}/${pkgname}" 2>/dev/null || cd "${startdir}"

    install -Dm755 bin/kautomator "${pkgdir}/usr/bin/kautomator"

    install -d "${pkgdir}/usr/share/${pkgname}/src"
    cp -r src/* "${pkgdir}/usr/share/${pkgname}/src/"

    install -Dm644 data/kautomator.service "${pkgdir}/usr/lib/systemd/user/kautomator.service"
    install -Dm644 data/kautomator_servicemenu.desktop "${pkgdir}/usr/share/kio/servicemenus/org.cesar.kautomator.desktop"
    install -Dm644 data/org.cesar.kautomator.desktop "${pkgdir}/usr/share/applications/org.cesar.kautomator.desktop"
    install -Dm644 README.md "${pkgdir}/usr/share/doc/${pkgname}/README.md"
}
