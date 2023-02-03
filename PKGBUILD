pkgname=potato-redux
pkgver=7
pkgrel=1
pkgdesc="A pomodoro timer for the shell with new features and QOL changes."
arch=('any')
url="https://github.com/Enchoseon/potato-redux"
license=('MIT')
conflicts=('potato')
depends=('alsa-utils')
optdepends=('sox: Brown noise support'
            'libnotify: Toast notification support'
            'python: Do Not Disturb support'
            'dbus-python: Do Not Disturb support')
source=('potato.sh'
        'doNotDisturb.py'
        'notification.wav'
        'LICENSE')
md5sums=('4aa885652605818d8e7761ae59f18497'
         '6a1f93699a0e933812b732cfdd26c3e9'
         'b01bacb54937c9bdd831f4d4ffd2e31c'
         '1ddcbd2862764b43d75fb1e484bf8912')
package() {
	install -D $srcdir/potato.sh $pkgdir/usr/bin/$pkgname
	install -D -m644 $srcdir/LICENSE $pkgdir/usr/share/licenses/$pkgname/LICENSE
	install -D $srcdir/notification.wav $pkgdir/usr/lib/$pkgname/notification.wav
	install -D $srcdir/doNotDisturb.py $pkgdir/usr/lib/$pkgname/doNotDisturb.py
}
