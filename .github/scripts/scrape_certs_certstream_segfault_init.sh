#!/usr/bin/env bash

##Usage:
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
export PATH="$HOME/bin:$PATH"
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
     curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/eget" -o "$HOME/bin/eget" ; chmod +xwr "$HOME/bin/eget"
fi
#Install Addons
#-----------------#
#Python + Pip
 #apprise
  pip install apprise --upgrade
 # ansi2txt
  pip install ansi2txt --upgrade
 # archey
  pip install archey4 --upgrade
#-----------------#
##Binaries
#7z
#if ! command -v 7z >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/7z" --to "$HOME/bin/7z" ; chmod +xwr "$HOME/bin/7z"
#fi
##anew
#if ! command -v anew >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/anew" --to "$HOME/bin/anew" ; chmod +xwr "$HOME/bin/anew"
#fi
##Btop
#if ! command -v btop >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/btop" --to "$HOME/bin/btop" ; chmod +xwr "$HOME/bin/btop"
#fi
##CertStream
#if ! command -v certstream >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/certstream" --to "$HOME/bin/certstream" ; chmod +xwr "$HOME/bin/certstream"
#fi
##croc
#if ! command -v croc >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/croc" --to "$HOME/bin/croc" ; chmod +xwr "$HOME/bin/croc"
#fi
# #HttpX
# if ! command -v httpx >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/httpx" --to "$HOME/bin/httpx" ; chmod +xwr "$HOME/bin/httpx"
# fi
# #Inscope
# if ! command -v inscope >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/inscope" --to "$HOME/bin/inscope" ; chmod +xwr "$HOME/bin/inscope"
# fi
# #ncdu
# if ! command -v ncdu >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/ncdu" --to "$HOME/bin/ncdu" ; chmod +xwr "$HOME/bin/ncdu"
# fi
# #Scopegen
# if ! command -v scopegen >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/scopegen" --to "$HOME/bin/scopegen" ; chmod +xwr "$HOME/bin/scopegen"
# fi
# #Scopeview
# if ! command -v scopeview >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Arsenal/main/scopeview/scopeview.sh" --to "$HOME/bin/scopeview" ; chmod +xwr "$HOME/bin/scopeview"
# fi     
# #SubXtract
# if ! command -v subxtract >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Arsenal/main/subxtract/subxtract.sh" --to "$HOME/bin/subxtract" ; chmod +xwr "$HOME/bin/subxtract"
# fi
# #Yq
# if ! command -v yq >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/yq" --to "$HOME/bin/yq" ; chmod +xwr "$HOME/bin/yq"
# fi
#EOF
set +x
#----------------------------------------------------------------------------#
#fetch Script
eget "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream_segfault.sh" --to "$HOME/bin/scrape_certs_certstream_segfault" && chmod +xwr "$HOME/bin/scrape_certs_certstream_segfault"

#Run Script
 echo -e "\n[+] Starting CertStream in Infinite Loop"
  nohup sh -c 'while :; bash $HOME/bin/scrape_certs_certstream_segfault_init && sleep 05; done' > /dev/null 2>&1 &
# if pgrep --full "certstream" > /dev/null; then
#   echo -e "\n[+] CertStream already Running"
#   ps aux | grep -i "certstream"
#   echo -e "\n[=] To kill: pgrep --full certstream | xargs kill -9"
# else
#   echo -e "\n[+] Starting CertStream in Infinite Loop"
#   nohup sh -c 'while :; do bash $HOME/bin/scrape_certs_certstream_segfault_init && sleep 05 && kill_stale_procs && sleep 05; done' > /dev/null 2>&1 &
# fi
#EOF
