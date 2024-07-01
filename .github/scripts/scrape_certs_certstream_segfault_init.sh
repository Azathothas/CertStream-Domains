#!/usr/bin/env bash

##Usage:
# Kill Previous Procs: pgrep --full certstream | xargs kill -9 2>/dev/null ; pgrep --full tmux | xargs kill -9 2>/dev/null
# tmux new-session -s "segfault"
# export VARS
#bash <(curl -qfsSL "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream_segfault_init.sh")
# [ctrl + b] + d to detach
# To kill (From a dettached Terminal): pgrep --full tmux | xargs kill -9
#Setup Dirs
#Persistance Dirs: https://www.thc.org/segfault/faq/
# /sec
# /onion
# /everyone
# $HOME --> /sec/root
# $HOME/bin --> /sec/root/bin
mkdir -p "$HOME/bin"
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export GITHUB_TOKEN="$CERTSTREAM_REPO_TOKEN"
#Install  eget
#Install Dos2Unix
if ! command -v dos2unix >/dev/null 2>&1; then
     sudo apt-get update -y && sudo apt-get install dos2unix -y
     sudo cp "$(which dos2unix)" "$HOME/bin/dos2unix"
     # curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Static-Binaries/main/busybox/busybox_amd_x86_64_musl_Linux" -o "$HOME/bin/busybox" ; chmod +xwr "$HOME/bin/busybox"
     # pushd "$HOME/bin" && "$HOME/bin/busybox" --install -s . ; popd
     # find "$HOME/bin" ! -name "dos2unix" ! -name "busybox" ! -name "*certstream*" -exec rm {} \; 2>/dev/null
fi
#Install eget
if ! command -v eget >/dev/null 2>&1; then
     curl -qfsSL "https://bin.ajam.dev/x86_64_Linux/eget" -o "$HOME/bin/eget" ; chmod +xwr "$HOME/bin/eget"
fi
#Install Addons
#-----------------#
#Python + Pip
  pip install --break-system-packages --upgrade pip || pip install --upgrade pip
  pip install pipx --upgrade --break-system-packages 2>/dev/null
 #ansi2txt
  pip install ansi2txt --upgrade
 #archey
  pip install archey4 --upgrade
 #For TG BOT Notifs
  pipx install "git+https://github.com/caronc/apprise.git" --force --include-deps
  pipx install "git+https://github.com/rahiel/telegram-send.git" --force --include-deps
#-----------------#
##Binaries
#7z
#if ! command -v 7z >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/7z" --to "$HOME/bin/7z" ; chmod +xwr "$HOME/bin/7z"
#fi
##anew
#if ! command -v anew >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/anew" --to "$HOME/bin/anew" ; chmod +xwr "$HOME/bin/anew"
     eget "https://bin.ajam.dev/x86_64_Linux/anew-rs" --to "$HOME/bin/anew-rs" ; chmod +xwr "$HOME/bin/anew-rs"
#fi
##Btop
#if ! command -v btop >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/btop" --to "$HOME/bin/btop" ; chmod +xwr "$HOME/bin/btop"
#fi
##CertStream
pip uninstall certstream --yes 2>/dev/null
#if ! command -v certstream >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/certstream" --to "$HOME/bin/certstream" ; chmod +xwr "$HOME/bin/certstream"
#fi
##certstream-server-go
#if ! command -v certstream-server-go >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/certstream-server-go" --to "$HOME/bin/certstream-server-go" ; chmod +xwr "$HOME/bin/certstream-server-go"
#fi
##croc
#if ! command -v croc >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/croc" --to "$HOME/bin/croc" ; chmod +xwr "$HOME/bin/croc"
#fi
##cutlines
#if ! command -v cutlines >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/cutlines" --to "$HOME/bin/cutlines" ; chmod +xwr "$HOME/bin/cutlines"
#fi
##duf
#if ! command -v duf >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/duf" --to "$HOME/bin/duf" ; chmod +xwr "$HOME/bin/duf"
#fi
##freeze
#if ! command -v freeze >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/freeze" --to "$HOME/bin/freeze" ; chmod +xwr "$HOME/bin/freeze"
#fi
##glow
#if ! command -v glow >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/glow" --to "$HOME/bin/glow" ; chmod +xwr "$HOME/bin/glow"
#fi
##HttpX
# if ! command -v httpx >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/httpx" --to "$HOME/bin/httpx" ; chmod +xwr "$HOME/bin/httpx"
# fi
##Inscope
# if ! command -v inscope >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/inscope" --to "$HOME/bin/inscope" ; chmod +xwr "$HOME/bin/inscope"
# fi
##ncdu
# if ! command -v ncdu >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/ncdu" --to "$HOME/bin/ncdu" ; chmod +xwr "$HOME/bin/ncdu"
# fi
##Scopegen
# if ! command -v scopegen >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/scopegen" --to "$HOME/bin/scopegen" ; chmod +xwr "$HOME/bin/scopegen"
# fi
##Scopeview
# if ! command -v scopeview >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/scopeview" --to "$HOME/bin/scopeview" ; chmod +xwr "$HOME/bin/scopeview"
# fi     
##SubXtract
# if ! command -v subxtract >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/subxtract" --to "$HOME/bin/subxtract" ; chmod +xwr "$HOME/bin/subxtract"
# fi
##Yq
# if ! command -v yq >/dev/null 2>&1; then
     eget "https://bin.ajam.dev/x86_64_Linux/yq" --to "$HOME/bin/yq" ; chmod +xwr "$HOME/bin/yq"
# fi
#EOF
set +x
#----------------------------------------------------------------------------#
#Run Script
export STREAM_TIME="$STREAM_TIME"
 echo -e "\n[+] Starting CertStream in Infinite Loop"
  #nohup sh -c 'while :; do bash $HOME/bin/scrape_certs_certstream_segfault && sleep 05; done' > /dev/null 2>&1 &
  while true
   do
     #fetch Script
      eget "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream_segfault.sh" --to "$HOME/bin/scrape_certs_certstream_segfault" && chmod +xwr "$HOME/bin/scrape_certs_certstream_segfault"
     #Run
     STREAM_TIME="$STREAM_TIME" bash "$HOME/bin/scrape_certs_certstream_segfault"
     #Sleep
     sleep 05
   #Repeat
   done     
# if pgrep --full "certstream" > /dev/null; then
#   echo -e "\n[+] CertStream already Running"
#   ps aux | grep -i "certstream"
#   echo -e "\n[=] To kill: pgrep --full certstream | xargs kill -9"
# else
#   echo -e "\n[+] Starting CertStream in Infinite Loop"
#   nohup sh -c 'while :; do bash $HOME/bin/scrape_certs_certstream_segfault_init && sleep 05 && kill_stale_procs && sleep 05; done' > /dev/null 2>&1 &
# fi
#EOF
