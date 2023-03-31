#!/usr/bin/env bash
cd "$(dirname "$0")"
install -D ./potato.sh /usr/bin/potato
install -D -m644 ./LICENSE /usr/share/licenses/potato-redux/LICENSE
install -D ./notification.wav /usr/lib/potato-redux/notification.wav
install -D ./doNotDisturb.py /usr/lib/potato-redux/doNotDisturb.py
