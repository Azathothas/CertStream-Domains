#!/usr/bin/env bash

# Run (Install Less)
# bash <(curl -qfsSL "https://@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/certstream_server_init.sh")

#kill zombie server  & Cleanup
pgrep -f "certstream-server-go" | xargs kill -9 2>/dev/null
rm "/tmp/server_config.yaml" 2>/dev/null 

##CertStream
pip uninstall certstream --yes 2>/dev/null
mkdir -p "$HOME/bin"
#btop
curl -qfsSL "https://bin.ajam.dev/x86_64_Linux/btop" -o "$HOME/bin/btop" ; chmod +xwr "$HOME/bin/btop"
#croc
curl -qfsSL "https://bin.ajam.dev/x86_64_Linux/croc" -o "$HOME/bin/croc" ; chmod +xwr "$HOME/bin/croc"
#eget
curl -qfsSL "https://bin.ajam.dev/x86_64_Linux/eget" -o "$HOME/bin/eget" ; chmod +xwr "$HOME/bin/eget"
#certstream
curl -qfsSL "https://bin.ajam.dev/x86_64_Linux/certstream" -o "$HOME/bin/certstream" ; chmod +xwr "$HOME/bin/certstream"
#certstream-server-go
curl -qfsSL "https://bin.ajam.dev/x86_64_Linux/certstream-server-go" -o "$HOME/bin/certstream-server-go" ; chmod +xwr "$HOME/bin/certstream-server-go"
#Configure certstream-server-go
#Get Latest Config
wget --quiet "https://raw.githubusercontent.com/Azathothas/Arsenal/main/certstream/server_config.yaml" -O "/tmp/server_config.yaml"
#Start Server  
nohup "$HOME/bin/certstream-server-go" -config "/tmp/server_config.yaml" >/dev/null 2>&1 &
netstat -tulpen
#EOF
