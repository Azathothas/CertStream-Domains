- #### ENV Vars
```bash
#Current User (Usually not root)
export CT_USER="$(whoami)"
#Git Repo User for git ops
export CERTSTREAM_REPO_USER="Azathothas"
#Git Repo Token for git ops
export CERTSTREAM_REPO_TOKEN="github_pat_token"
#Optional Telegram Notifications
export INVENTORY_TG_BOT="123456786:AAFuqVEtDWolSnueIUEBSsmqoqO_DJuwkOSPOsqPI/-12568654896200"
#Stream Time (Perform GIT OPS && Restart Certstream)
export STREAM_TIME="69m"
#Systmp (System TEMP Dir, usually /tmp)
SYSTMP="$(/usr/bin/dirname $(/bin/mktemp -u))" && export SYSTMP="${SYSTMP}"
```

- #### [SystemD](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files) `/etc/systemd/system/certstream.service`
```bash
sudo curl -qfsSL "https://bin.ajam.dev/$(uname -m)/curl" -o "/usr/bin/curl" && sudo chmod +x "/usr/bin/curl"
sudo curl -qfsSL "https://bin.ajam.dev/$(uname -m)/tmux" -o "/usr/bin/tmux" && sudo chmod +x "/usr/bin/tmux"
sudo mkdir -p "/etc/systemd/system/" && sudo touch "/etc/systemd/system/certstream.service"
cat << 'EOF' | sed -e "s|CT_USER|$CT_USER|" -e "s|CTR_USER|$CERTSTREAM_REPO_USER|" -e "s|CTR_TOKEN|$CERTSTREAM_REPO_TOKEN|" -e "s|CTR_TG|$INVENTORY_TG_BOT|" -e "s|CTR_TIME|$STREAM_TIME|" -e "s|CTR_TMP|$SYSTMP|" | sudo tee "/etc/systemd/system/certstream.service"
[Unit]
Description=Certstreamer
Wants=network-online.target
After=network-online.target network.target

[Service]
Type=forking
User=CT_USER
Environment="CERTSTREAM_REPO_USER=CTR_USER"
Environment="CERTSTREAM_REPO_TOKEN=CTR_TOKEN"
Environment="INVENTORY_TG_BOT=CTR_TG"
Environment="STREAM_TIME=CTR_TIME"
Envronment="SYSTMP=CTR_TMP"
ExecStartPre=/bin/bash -c '/usr/bin/tmux kill-session -t "certstream" >/dev/null 2>&1 || true'
ExecStartPre=/bin/bash -c '/usr/bin/mkdir -p "CTR_TMP/Certstream.tmp"'
ExecStartPre=/bin/bash -c '/usr/bin/curl -qfsSL "https://${CERTSTREAM_REPO_USER}:${CERTSTREAM_REPO_TOKEN}@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream_init.sh" -o "CTR_TMP/Certstream.tmp/init.sh" || true'
ExecStartPre=/bin/bash -c '/usr/bin/chmod +x "CTR_TMP/Certstream.tmp/init.sh"'
ExecStart=/usr/bin/tmux new-session -d -s certstream /usr/bin/bash -c 'bash "CTR_TMP/Certstream.tmp/init.sh"'
ExecStartPost=/bin/bash -c '/usr/bin/tmux ls || true'
ExecStop=/bin/bash -c '/usr/bin/tmux kill-session -t "certstream" >/dev/null 2>&1 || true'
ExecStopPost=/bin/bash -c '/usr/bin/find "$(/usr/bin/dirname $(/bin/mktemp -u))" -maxdepth 1 -type d -iname "*certstream*" -exec /bin/rm -rf {} \; >/dev/null 2>&1 || true'
RemainAfterExit=yes
Restart=always
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

#Start & Debug
sudo systemctl daemon-reload
sudo systemctl enable "certstream.service" --now
sudo systemctl restart "certstream.service"
sudo systemctl status "certstream.service"
journalctl -xeu "certstream.service"
tmux ls
```

- #### [OpenRC](https://wiki.gentoo.org/wiki/OpenRC) `/etc/init.d/certstream`
```bash
##REF: https://github.com/OpenRC/openrc/blob/master/service-script-guide.md
# https://wiki.alpinelinux.org/wiki/Writing_Init_Scripts

sudo curl -qfsSL "https://bin.ajam.dev/$(uname -m)/curl" -o "/usr/bin/curl" && sudo chmod +x "/usr/bin/curl"
sudo curl -qfsSL "https://bin.ajam.dev/$(uname -m)/tmux" -o "/usr/bin/tmux" && sudo chmod +x "/usr/bin/tmux"
sudo mkdir -p "/etc/init.d/" && sudo touch "/etc/init.d/certstream"
cat << 'EOF' | sed -e "s|CT_USER|$CT_USER|" -e "s|CTR_USER|$CERTSTREAM_REPO_USER|" -e "s|CTR_TOKEN|$CERTSTREAM_REPO_TOKEN|" -e "s|CTR_TG|$INVENTORY_TG_BOT|" -e "s|CTR_TIME|$STREAM_TIME|" -e "s|CTR_TMP|$SYSTMP|" | sudo tee "/etc/init.d/certstream"
#!/sbin/openrc-run

export CERTSTREAM_REPO_USER="CTR_USER"
export CERTSTREAM_REPO_TOKEN="CTR_TOKEN"
export INVENTORY_TG_BOT="CTR_TG"
export STREAM_TIME="CTR_TIME"
export SYSTMP="CTR_TMP"

description="Certstreamer"
command="/usr/bin/tmux"
command_args="new-session -d -s certstream /bin/bash -c 'bash "CTR_TMP/Certstream.tmp/init.sh"'"
command_user="CT_USER"
command_background="yes"
start_stop_daemon_args="--background"
retry="yes"
pidfile="/var/run/certstream.pid"
respawn_delay=5
respawn_max=0

depend() {
    need net
    after network
}

start_pre() {
    ebegin "Initializing ENV"
    /bin/sleep 10
    /usr/bin/tmux kill-session -t "certstream" >/dev/null 2>&1 || true
    SYSTMP="$(/usr/bin/dirname $(/bin/mktemp -u))"
    /usr/bin/find "$SYSTMP" -maxdepth 1 -type d -iname "*certstream*" -exec /bin/rm -rf {} \; >/dev/null 2>&1 || true
    /bin/mkdir -p "$SYSTMP/Certstream.tmp"
    /usr/bin/curl -qfsSL "https://${CERTSTREAM_REPO_USER}:${CERTSTREAM_REPO_TOKEN}@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream_init.sh" -o "$SYSTMP/Certstream.tmp/init.sh" || true
    /bin/chmod +x "$SYSTMP/Certstream.tmp/init.sh"
}

status() {
    pid=$(/usr/bin/pgrep -f "Certstream.tmp/init.sh")
    if [ -n "$pid" ]; then
        ebegin "Certstream is running (PID: $pid)"
        /usr/bin/tmux ls
        eend 0
    else
        ebegin "certstream is not running"
        eend 1
    fi
}

stop() {
    ebegin "Stopping Certstream & Killing Tmux Session"
    /usr/bin/tmux kill-session -t "certstream" >/dev/null 2>&1 || true
    SYSTMP="$(/usr/bin/dirname $(/bin/mktemp -u))"
    /usr/bin/find "$SYSTMP" -maxdepth 1 -type d -iname "*certstream*" -exec /bin/rm -rf {} \; >/dev/null 2>&1 || true
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
sudo chmod +x "/etc/init.d/certstream"
sudo rc-update add "certstream" default
sudo rc-service "certstream" start
sudo rc-service "certstream" status
tmux ls
```
