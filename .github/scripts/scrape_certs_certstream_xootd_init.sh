#!/data/data/com.termux/files/usr/bin/env bash

##Usage:
# Kill Previous Procs: pgrep --full certstream | xargs kill -9 2>/dev/null ; pgrep --full tmux | xargs kill -9 2>/dev/null
# tmux new-session -s "certstream"
# export VARS
#bash <(curl -qfsSL "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream_xootd_init.sh")
# [ctrl + b] + d to detach
# To kill (From a dettached Terminal): pgrep --full tmux | xargs kill -9
#Setup Dirs
#PREFIX: /data/data/com.termux/files/usr [$PREFIX]
#ROOT=/data/data/com.termux/
#HOME=/data/data/com.termux/files/home [ $PREFIX ]
#Bin=/data/data/com.termux/files/usr/bin/ [ /data/data/com.termux/files/usr/bin/ ]
export GITHUB_TOKEN="$CERTSTREAM_REPO_TOKEN"
#Install  eget
#Install Dos2Unix
if ! command -v dos2unix >/dev/null 2>&1; then
     pkg update -y && sudo pkg dos2unix -y
fi
#Install eget
if ! command -v eget >/dev/null 2>&1; then
     curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/aarch64_arm64_v8a_Android/eget" -o "$PREFIX/bin/eget" && chmod +xwr "$PREFIX/bin/eget"
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
pkg update -y
#7z
if ! command -v 7z >/dev/null 2>&1; then
     pkg install 7z -y
fi
##anew
if ! command -v anew >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/aarch64_arm64_v8a_Android/anew" --to "$PREFIX/bin/anew" ; chmod +xwr "$PREFIX/bin/anew"
fi
##Btop
# if ! command -v btop >/dev/null 2>&1; then
#      eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/aarch64_arm64_v8a_Android/btop" --to "$PREFIX/bin/btop" ; chmod +xwr "$PREFIX/bin/btop"
# fi
##CertStream
pip uninstall certstream --yes 2>/dev/null
if ! command -v certstream >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/aarch64_arm64_v8a_Android/certstream" --to "$PREFIX/bin/certstream" ; chmod +xwr "$PREFIX/bin/certstream"
fi
##certstream-server-go
pip uninstall certstream-server-go --yes 2>/dev/null
if ! command -v certstream-server-go >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/aarch64_arm64_v8a_Android/certstream-server-go" --to "$PREFIX/bin/certstream-server-go" ; chmod +xwr "$PREFIX/bin/certstream-server-go"
fi
##croc
if ! command -v croc >/dev/null 2>&1; then
     pkg install croc -y
fi
##duf
if ! command -v duf >/dev/null 2>&1; then
     pkg install duf -y
fi
##HttpX
if ! command -v httpx >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/aarch64_arm64_v8a_Android/httpx" --to "$PREFIX/bin/httpx" ; chmod +xwr "$PREFIX/bin/httpx"
fi
##jq
if ! command -v jq >/dev/null 2>&1; then
     pkg install jq -y
fi
##Inscope
if ! command -v inscope >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/aarch64_arm64_v8a_Android/inscope" --to "$PREFIX/bin/inscope" ; chmod +xwr "$PREFIX/bin/inscope"
fi
##ncdu
if ! command -v ncdu >/dev/null 2>&1; then
     pkg install ncdu -y
fi
##Scopegen
if ! command -v scopegen >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/aarch64_arm64_v8a_Android/scopegen" --to "$PREFIX/bin/scopegen" ; chmod +xwr "$PREFIX/bin/scopegen"
fi
##Scopeview
if ! command -v scopeview >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Arsenal/main/scopeview/scopeview.sh" --to "$PREFIX/bin/scopeview" ; chmod +xwr "$PREFIX/bin/scopeview"
fi     
##SubXtract
if ! command -v subxtract >/dev/null 2>&1; then
     eget "https://raw.githubusercontent.com/Azathothas/Arsenal/main/subxtract/subxtract.sh" --to "$PREFIX/bin/subxtract" ; chmod +xwr "$PREFIX/bin/subxtract"
fi
##Yq
if ! command -v yq >/dev/null 2>&1; then
     pkg install yq -y
fi
#----------------------------------------------------------------------------#
set +x
#Run Script
 echo -e "\n[+] Starting CertStream in Infinite Loop"
 #nohup sh -c 'while :; do bash $PREFIX/bin/scrape_certs_certstream_xootd && sleep 05; done' > /dev/null 2>&1 &
   while true
   do
      #fetch Script
      eget "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream_xootd.sh" --to "$PREFIX/bin/scrape_certs_certstream_xootd" && chmod +xwr "$PREFIX/bin/scrape_certs_certstream_xootd"
      #Run
      bash "$PREFIX/bin/scrape_certs_certstream_xootd"
      #Sleep
      sleep 05
   #Repeat
   done
#EOF
