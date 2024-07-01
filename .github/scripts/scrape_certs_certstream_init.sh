#!/usr/bin/env bash

##Requires: bash + coreutils + curl + findutils + git + moreutils + util-linux + wget
# sudo apt-get update -y && sudo apt-get install bash coreutils findutils git grep moreutils util-linux wget -y -qq
# apk add bash coreutils croc curl diffutils dos2unix file findutils fuse3 git gnupg grep htop iputils jq lm-sensors lsof moreutils netcat-openbsd net-tools pciutils procs python3 sed socat sudo sysfsutils tar util-linux wget zip --latest --upgrade --no-interactive


##ENV
#export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
#export CERTSTREAM_REPO_USER="${GITHUB_REPO USERNAME}"
#export CERTSTREAM_REPO_TOKEN="${SCOPED TOKEN WITH READ WRITE ACCESS TO GITHUB_REPO}"
#export STREAM_TIME="{TIME_IN_MINUTES}m"

##Usage:
# Kill Previous Procs: pgrep -f certstream | xargs kill -9 2>/dev/null ; pgrep -f tmux | xargs kill -9 2>/dev/null
# tmux new-session -s "certstream"
# export VARS
#bash <(curl -qfsSL "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream_init.sh")
# [ctrl + b] + d to detach
# To kill (From a dettached Terminal): pgrep -f tmux | xargs kill -9

#------------------------------------------------------------------------------------#
#Setup Dirs
mkdir -p "$HOME/bin"
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export GITHUB_TOKEN="$CERTSTREAM_REPO_TOKEN"
#------------------------------------------------------------------------------------#

#------------------------------------------------------------------------------------#
#Install Addons & Deps :: https://github.com/Azathothas/Arsenal/blob/main/misc/Linux/install_bb_tools.sh
bash <(curl -qfsSL "https://pub.ajam.dev/repos/Azathothas/Arsenal/misc/Linux/install_bb_tools.sh")
#------------------------------------------------------------------------------------#


#------------------------------------------------------------------------------------#
#Run Script
export STREAM_TIME="$STREAM_TIME"
exec -a "certstream_init_loop" zapper -f -a 'certstream --> https://github.com/Azathothas/CertStream-Domains' bash <<EOF
 echo -e "\n[+] Starting CertStream in Infinite Loop"
  while true
   do
     #fetch Script
      eget "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream.sh" --to "$HOME/bin/scrape_certs_certstream" && chmod +xwr "$HOME/bin/scrape_certs_certstream"
     #Run
     STREAM_TIME="$STREAM_TIME" bash "$HOME/bin/scrape_certs_certstream"
     #Sleep
     sleep 05
   #Repeat
   done
EOF
##END
#------------------------------------------------------------------------------------#
