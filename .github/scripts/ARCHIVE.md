- #### ENV Vars
```bash
#Current User (Usually not root)
export CT_USER="$(whoami)"
#Location for Archive ($HOME/certstream_data)
export CT_ARCHIVE="${HOME}/certstream_data"
#Systmp (System TEMP Dir, usually /tmp)
SYSTMP="$(/usr/bin/dirname $(/bin/mktemp -u))" && export SYSTMP="${SYSTMP}"
```

- #### [SystemD](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files) `/etc/systemd/system/certstream_archive.service`
```bash
sudo curl -qfsSL "https://bin.ajam.dev/$(uname -m)/curl" -o "/usr/bin/curl" && sudo chmod +x "/usr/bin/curl"
sudo curl -qfsSL "https://bin.ajam.dev/$(uname -m)/tmux" -o "/usr/bin/tmux" && sudo chmod +x "/usr/bin/tmux"
sudo mkdir -p "/etc/systemd/system/" && sudo touch "/etc/systemd/system/certstream_archive.service"
cat << 'EOF' | sed -e "s|CT_USER|$CT_USER|" -e "s|C_ARCHIVE|$CT_ARCHIVE|" -e "s|CTR_TMP|$SYSTMP|" | sudo tee "/etc/systemd/system/certstream_archive.service"
[Unit]
Description=Certstreamer
Wants=network-online.target
After=network-online.target network.target

[Service]
Type=forking
User=CT_USER
Environment="CT_ARCHIVE=C_ARCHIVE"
ExecStartPre=/bin/bash -c '/usr/bin/tmux kill-session -t "certstream-archive" >/dev/null 2>&1 || true'
ExecStartPre=/bin/bash -c '/usr/bin/mkdir -p "CTR_TMP/Certstream.tmp"'
ExecStartPre=/bin/bash -c '/usr/bin/curl -qfsSL "https://raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/certstream_archive.sh" -o "CTR_TMP/Certstream.tmp/archive.sh" || true'
ExecStartPre=/bin/bash -c '/usr/bin/chmod +x "CTR_TMP/Certstream.tmp/archive.sh"'
ExecStart=/usr/bin/tmux new-session -d -s certstream-archive /usr/bin/bash -c 'sudo -u "CT_USER" bash "CTR_TMP/Certstream.tmp/archive.sh"'
ExecStartPost=/bin/bash -c '/usr/bin/tmux ls || true'
ExecStop=/bin/bash -c '/usr/bin/tmux kill-session -t "certstream-archive" >/dev/null 2>&1 || true'
RemainAfterExit=yes
Restart=always
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

#Start & Debug
sudo systemctl daemon-reload
sudo systemctl enable "certstream_archive.service" --now
sudo systemctl restart "certstream_archive.service"
sudo systemctl status "certstream_archive.service"
journalctl -xeu "certstream_archive.service"
tmux ls
tmux attach-session -t "certstream-archive"
```

- #### [OpenRC](https://wiki.gentoo.org/wiki/OpenRC) `/etc/init.d/certstream_archive`
```bash
##REF: https://github.com/OpenRC/openrc/blob/master/service-script-guide.md
# https://wiki.alpinelinux.org/wiki/Writing_Init_Scripts

sudo curl -qfsSL "https://bin.ajam.dev/$(uname -m)/curl" -o "/usr/bin/curl" && sudo chmod +x "/usr/bin/curl"
sudo curl -qfsSL "https://bin.ajam.dev/$(uname -m)/tmux" -o "/usr/bin/tmux" && sudo chmod +x "/usr/bin/tmux"
sudo mkdir -p "/etc/init.d/" && sudo touch "/etc/init.d/certstream_archive"
cat << 'EOF' | sed -e "s|CT_USER|$CT_USER|" -e "s|C_ARCHIVE|$CT_ARCHIVE|" -e "s|CTR_TMP|$SYSTMP|" | sudo tee "/etc/init.d/certstream_archive"
#!/sbin/openrc-run

export CT_ARCHIVE="C_ARCHIVE"
export SYSTMP="CTR_TMP"

description="Certstreamer"
command="/usr/bin/tmux"
command_args="new-session -d -s certstream-archive /bin/bash -c 'bash "CTR_TMP/Certstream.tmp/archive.sh"'"
command_user="CT_USER"
command_background="yes"
start_stop_daemon_args="--background"
retry="yes"
pidfile="/var/run/certstream_archive.pid"
respawn_delay=5
respawn_max=0

depend() {
    need net
    after network
}

start_pre() {
    ebegin "Initializing ENV"
    /bin/sleep 10
    /usr/bin/tmux kill-session -t "certstream-archive" >/dev/null 2>&1 || true
    SYSTMP="$(/usr/bin/dirname $(/bin/mktemp -u))"
    /bin/mkdir -p "$SYSTMP/Certstream.tmp"
    /usr/bin/curl -qfsSL "https://raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/certstream_archive.sh" -o "$SYSTMP/Certstream.tmp/archive.sh" || true
    /bin/chmod +x "$SYSTMP/Certstream.tmp/archive.sh"
}

status() {
    pid=$(/usr/bin/pgrep -f "Certstream.tmp/archive.sh")
    if [ -n "$pid" ]; then
        ebegin "Certstream-Archiver is running (PID: $pid)"
        /usr/bin/tmux ls
        eend 0
    else
        ebegin "Certstream-Archiver is not running"
        eend 1
    fi
}

stop() {
    ebegin "Stopping Certstream & Killing Tmux Session"
    /usr/bin/tmux kill-session -t "certstream-archive" >/dev/null 2>&1 || true
    SYSTMP="$(/usr/bin/dirname $(/bin/mktemp -u))"
}

restart() {
    ebegin "Restarting certstream"
    stop 2>&1 || true
    start
    /usr/bin/tmux ls
    eend $?
}
EOF

#Start & Debug
sudo chmod +x "/etc/init.d/certstream_archive"
sudo rc-update add "certstream-archive" default
sudo rc-service "certstream-archive" start
sudo rc-service "certstream-archive" status
tmux ls
tmux attach-session -t "certstream-archive"
```
