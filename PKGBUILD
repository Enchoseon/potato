# Maintainer: Enchoseon <>
# Contributor: bladtman
pkgname=potato-redux
pkgver=7
pkgrel=1
pkgdesc="A pomodoro timer for the shell with new features and quality-of-life changes."
arch=('any')
url="https://github.com/Enchoseon/potato-redux"
license=('MIT')
conflicts=('potato')
depends=('alsa-utils'
         'util-linux')
optdepends=('sox: Brown noise support'
            'libnotify: Toast notification support'
            'python: Do Not Disturb support'
            'dbus-python: Do Not Disturb support',
            'kdeconnect: Smartphone notification support')
source=('potato.sh'
        'doNotDisturb.py'
        'notification.wav'
        'LICENSE')
md5sums=('e5b2b9f443114e95b653904f89e3b5e4'
         '39a87a4f9151e0b7328204aaba33d7ec'
         '8ec2e9a6856be1d9eced3e5263aead09'
         '1ddcbd2862764b43d75fb1e484bf8912')
package() {
	install -D $srcdir/potato.sh $pkgdir/usr/bin/potato
	install -D -m644 $srcdir/LICENSE $pkgdir/usr/share/licenses/$pkgname/LICENSE
	install -D $srcdir/notification.wav $pkgdir/usr/lib/$pkgname/notification.wav
	install -D $srcdir/doNotDisturb.py $pkgdir/usr/lib/$pkgname/doNotDisturb.py
}
