pkgname=potato
pkgver=7
pkgrel=1
pkgdesc="A pomodoro timer for the shell. This fork sends toasts and enables Do Not Disturb."
arch=('any')
url="https://github.com/Enchoseon/potato"
license=('MIT')
depends=('alsa-utils'
         'libnotify'
         'python'
         'dbus-python')
optdepend=('sox: Brown noise support')
source=('potato.sh'
        'doNotDisturb.py'
        'notification.wav'
        'LICENSE')
md5sums=('86c23380e0554fe5a669a734a5cd2ffe'
         '6a1f93699a0e933812b732cfdd26c3e9'
         'b01bacb54937c9bdd831f4d4ffd2e31c'
         '1ddcbd2862764b43d75fb1e484bf8912')
package() {
	install -D $srcdir/potato.sh $pkgdir/usr/bin/$pkgname
	install -D -m644 $srcdir/LICENSE $pkgdir/usr/share/licenses/$pkgname/LICENSE
	install -D $srcdir/notification.wav $pkgdir/usr/lib/$pkgname/notification.wav
	install -D $srcdir/doNotDisturb.py $pkgdir/usr/lib/$pkgname/doNotDisturb.py
}
