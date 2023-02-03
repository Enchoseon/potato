pkgname=potato
pkgver=6
pkgrel=1
pkgdesc="A pomodoro timer for the shell. This fork sends toasts and enables Do Not Disturb."
arch=('any')
url="https://github.com/Enchoseon/potato"
license=('MIT')
depends=('alsa-utils'
         'libnotify'
         'python'
         'dbus-python')
source=('potato.sh'
        'doNotDisturb.py'
        'notification.wav'
        'LICENSE')
md5sums=('a7b78d3d773a50e6160b26ab0efadddc'
         '6a1f93699a0e933812b732cfdd26c3e9'
         'b01bacb54937c9bdd831f4d4ffd2e31c'
         '1ddcbd2862764b43d75fb1e484bf8912')
package() {
	install -D $srcdir/potato.sh $pkgdir/usr/bin/$pkgname
	install -D -m644 $srcdir/LICENSE $pkgdir/usr/share/licenses/$pkgname/LICENSE
	install -D $srcdir/notification.wav $pkgdir/usr/lib/$pkgname/notification.wav
	install -D $srcdir/doNotDisturb.py $pkgdir/usr/lib/$pkgname/doNotDisturb.py
}
