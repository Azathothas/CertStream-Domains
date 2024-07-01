#!/data/data/com.termux/files/usr/bin/env bash

# Install (Recommended)
# eget "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream_xootd.sh" --to "$HOME/.data/scrape_certs_certstream_xootd" && chmod +xwr "$HOME/.data/scrape_certs_certstream_xootd" 
# bash "$HOME/.data/scrape_certs_certstream_xootd"
# Run (Install Less)
# bash <(curl -qfsSL "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream_xootd.sh")

# Time
START_TIME=$(date +%s)

# For debug
#set -x

#A bit of Styling
RED='\033[31m'
GREEN='\033[32m'
DGREEN='\033[38;5;28m'
GREY='\033[37m'
BLUE='\033[34m'
YELLOW='\033[33m'
PURPLE='\033[35m'
PINK='\033[38;5;206m'
VIOLET='\033[0;35m'
RESET='\033[0m'
NC='\033[0m'

#----------------------------------------------------------------------------#
#Kill Stale Processes
kill_stale_procs()
  {
  #procs
   pgrep --full inscope | xargs kill -9 2>/dev/null
   #Files 
   find "/data/data/com.termux/files/usr/tmp" -maxdepth 1 -name '*certstream*' -exec rm {} -rf \; 2>/dev/null
   find "/data/data/com.termux/files/usr/tmp" -maxdepth 1 -name '*Automata*' -exec rm {} -rf \; 2>/dev/null
   find "/data/data/com.termux/files/usr/tmp" -maxdepth 1 -name '*.log' -exec rm {} -rf \; 2>/dev/null
   find "/data/data/com.termux/files/usr/tmp" -maxdepth 1 -name '*.md' -exec rm {} -rf \; 2>/dev/null
   find "/data/data/com.termux/files/usr/tmp" -maxdepth 1 -name '*.txt' -exec rm {} -rf \; 2>/dev/null
   find "/data/data/com.termux/files/usr/tmp" -maxdepth 1 -name '*.7z' -exec rm {} -rf \; 2>/dev/null
   find "/data/data/com.termux/files/usr/tmp" -maxdepth 1 -name '*.zip' -exec rm {} -rf \; 2>/dev/null
  }
 #Export
 export -f kill_stale_procs
#Run Script
  kill_stale_procs
#----------------------------------------------------------------------------#
#Setup Dirs
#PREFIX: /data/data/com.termux/files/usr [$PREFIX]
#ROOT=/data/data/com.termux/
#HOME=/data/data/com.termux/files/home [ $PREFIX ]
#Bin=/data/data/com.termux/files/usr/bin/ [ /data/data/com.termux/files/usr/bin/ ]
#TMP=/data/data/com.termux/files/usr/tmp
#----------------------------------------------------------------------------#
# ENV:VARS (Read from $ENV)
#CERTSTREAM_REPO_USER
#CERTSTREAM_REPO_TOKEN
#INVENTORY_TG_BOT
#----------------------------------------------------------------------------#
#Gh
GH_USER="$CERTSTREAM_REPO_USER" && export GH_USER="$GH_USER"
export GITHUB_TOKEN="$CERTSTREAM_REPO_TOKEN"
#Setup Repo
mkdir -p "$HOME/Github"
# mkdir -p "/data/data/com.termux/files/home/Github"
if [ ! -d "/data/data/com.termux/files/home/Github/CertStream-Domains" ]; then
   #https://github.blog/2020-12-21-get-up-to-speed-with-partial-clone-and-shallow-clone/
      pushd "$HOME/Github" && git clone --filter="blob:none" "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@github.com/Azathothas/CertStream-Domains.git"
      cd "./CertStream-Domains" && CERTSTREAM_REPO="$(realpath .)" ; export CERTSTREAM_REPO="$CERTSTREAM_REPO" ; popd
else       
    #Check if git is too bloated
     if [ -d "$HOME/Github/CertStream-Domains/.git" ] && [ "$(du -sk $HOME/Github/CertStream-Domains/.git | cut -f1)" -ge "8500000" ]; then
         echo -e "\n[+] $HOME/Github/CertStream-Domains/.git exceeds 8.5 GB\n"
         #Purge
         rm -rf "$HOME/Github/CertStream-Domains" 2>/dev/null
         #re(Clone)
         pushd "$HOME" && git clone --filter="blob:none" "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@github.com/Azathothas/CertStream-Domains.git"
         #Export PATH
         cd "$HOME/Github/CertStream-Domains" && CERTSTREAM_REPO="$(realpath .)" ; export CERTSTREAM_REPO="$CERTSTREAM_REPO" ; popd
    else
          pushd "$HOME/Github/CertStream-Domains" ; git fetch origin && git reset --hard origin/main ; git checkout HEAD -- ; git pull origin main
          CERTSTREAM_REPO="$(realpath .)" ; export CERTSTREAM_REPO="$CERTSTREAM_REPO" ; popd
    fi
fi
#DANGEROUS && DUMB
# # HOST_IP | REGION
# HOST_IP="$(curl --ipv4 -qfskSL http://ipv4.whatismyip.akamai.com | sed 's/[[:space:]]*$//' )" && export HOST_IP="$HOST_IP"
# HOST_REGION="$(curl --ipv4 -qfskSL "http://ip-api.com/json/" | jq -r '"\(.country | gsub(" "; "-"))-\(.city | gsub(" "; "-"))"')" && export HOST_REGION="$HOST_REGION"
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#Run
# ~ 50 K Subs --> 1MB
# Runs 66 Mins
 #timeout -k 1m 400m certstream --full --json | jq -r '.data.leaf_cert.all_domains[]' > "/data/data/com.termux/files/usr/tmp/certstream_domains.txt"
 echo -e "\n [+] Streaming...\n"
#   #Configure certstream-server-go
#    #kill zombie server
#     pgrep -f "certstream-server-go" | xargs kill -9 2>/dev/null
#     rm "/data/data/com.termux/files/usr/tmp/server_config.yaml" 2>/dev/null 
#    #Get Latest Config
#     wget "https://raw.githubusercontent.com/Azathothas/Arsenal/main/certstream/server_config.yaml" -O "/data/data/com.termux/files/usr/tmp/server_config.yaml"
#  #Start Server   
#  nohup certstream-server-go -config "/data/data/com.termux/files/usr/tmp/server_config.yaml" >/dev/null 2>&1 &
 #Start client
 timeout --preserve-status --foreground -k 1m 66m certstream -url "wss://certstream-server.prashansa.com.np" -domains-only -insecure -quiet > "/data/data/com.termux/files/usr/tmp/certstream_domains.txt"
 #timeout --preserve-status --foreground -k 1m 66m certstream -url "ws://localhost:8888" -domains-only -quiet > "/data/data/com.termux/files/usr/tmp/certstream_domains.txt"
 #timeout --preserve-status --foreground -k 1m 66m certstream -url "wss://certstream.calidog.io" -domains-only -quiet > "/data/data/com.termux/files/usr/tmp/certstream_domains.txt"
 #timeout --preserve-status --foreground -k 1m 66m certstream > "/data/data/com.termux/files/usr/tmp/certstream_domains.txt"
#Filter & Parse
 #Remove Spaces
  sed -E '/^[[:space:]]*$/d' -i "/data/data/com.termux/files/usr/tmp/certstream_domains.txt"
 #Remove Wildcard
  sed 's/^\*\.\(.*\)/\1/; s/^\*//' -i "/data/data/com.termux/files/usr/tmp/certstream_domains.txt"
 #To Lowercase
  sed 's/[A-Z]/\L&/g' -i "/data/data/com.termux/files/usr/tmp/certstream_domains.txt"
 #Remove spaces v2.0
  sed 's/^[[:space:]]*//;s/[[:space:]]*$//' -i "/data/data/com.termux/files/usr/tmp/certstream_domains.txt"
 #Remove `:`
  sed '/:/d' -i "/data/data/com.termux/files/usr/tmp/certstream_domains.txt" 
#Sort
 sort -u "/data/data/com.termux/files/usr/tmp/certstream_domains.txt" -o "/data/data/com.termux/files/usr/tmp/certstream_domains.txt"
 #TG-BOT
 TOTAL_SUBSTREAMED_SUBS="$(wc -l < /data/data/com.termux/files/usr/tmp/certstream_domains.txt)" && export TOTAL_SUBSTREAMED_SUBS="$TOTAL_SUBSTREAMED_SUBS" ; echo "TOTAL_SUBSTREAMED_SUBS: $TOTAL_SUBSTREAMED_SUBS"
 SUBSTREAM_SIZE="$(du -h /data/data/com.termux/files/usr/tmp/certstream_domains.txt | awk '{print $1}')" && export SUBSTREAM_SIZE="$SUBSTREAM_SIZE" ; echo "SUBSTREAM_SIZE: $SUBSTREAM_SIZE"
# 7zip
 7z a -r -t7z -mx="9" -mmt="$(($(nproc)+1))" "/data/data/com.termux/files/usr/tmp/certstream_domains.7z" "/data/data/com.termux/files/usr/tmp/certstream_domains.txt" 2>/dev/null
 sha256sum "/data/data/com.termux/files/usr/tmp/certstream_domains.7z"
 SUBSTREAM_ARCHIVE_SIZE="$(du -h /data/data/com.termux/files/usr/tmp/certstream_domains.7z | awk '{print $1}')" && export SUBSTREAM_ARCHIVE_SIZE="$SUBSTREAM_ARCHIVE_SIZE" ; echo "SUBSTREAM_ARCHIVE_SIZE: $SUBSTREAM_ARCHIVE_SIZE"
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
# Time meth
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
ELAPSED_TIME_MINUTES=$((ELAPSED_TIME / 60))
ELAPSED_TIME_HOURS=$((ELAPSED_TIME / 3600))
START_TIME_NPT=$(TZ="Asia/Kathmandu" date -d "@$START_TIME" "+%Y-%m-%d %I:%M:%S %p Nepal TIME")
END_TIME_NPT=$(TZ="Asia/Kathmandu" date -d "@$END_TIME" "+%Y-%m-%d %I:%M:%S %p Nepal TIME")
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------# 
#GitOps
#Git Pull
 pushd "$CERTSTREAM_REPO" && git pull origin main ; popd   
#Add To Repo
 mkdir -p "$CERTSTREAM_REPO/Raw/Latest"
 SAFE_END_TIME_NPT="$(echo $END_TIME_NPT | sed 's/[ -]/_/g; s/:/_/g')"
 cp "/data/data/com.termux/files/usr/tmp/certstream_domains.7z" "$CERTSTREAM_REPO/Raw/Latest/certstream_$SAFE_END_TIME_NPT.7z" 
# chdir to Inventory
 cd "$CERTSTREAM_REPO"
# Add repo wise config
 git config user.email "AjamX101@gmail.com"
 git config user.name "Azathothas"
# Pull to sync updates
 git config --global pull.rebase true
 git pull origin main
# Add everything
 git add --all --verbose
 git commit -m "xootd --> CertStreamed SSL|TLS Certs (Termux)" 
# Pull one last time
 git config --global pull.rebase true
 git pull origin main
# Finally push 
 # Try pushing
 if git push -u origin main; then
    echo "GIT_PUSH_PASSED" > "/data/data/com.termux/files/usr/tmp/gh_push.txt"
 else
    #we fucked up
    echo "GIT_PUSH_FAILED" > "/data/data/com.termux/files/usr/tmp/gh_push.txt"
    echo "GIT_PUSH_FAILED=true" >> $GITHUB_ENV 2>/dev/null
    #Wait few mins
    sleep 120
    git config --global pull.rebase true
    git pull origin main
    # Check again
    if git push -u origin main; then
       echo "GIT_PUSH_PASSED" > "/data/data/com.termux/files/usr/tmp/gh_push.txt"
       tgbot_push_success
    else
       sleep 200
       if git push -u origin main; then
          echo "GIT_PUSH_PASSED" > "/data/data/com.termux/files/usr/tmp/gh_push.txt"
       else
          git config --global pull.rebase true
          git pull origin main --no-edit
          if git push -u origin main; then
             echo "GIT_PUSH_PASSED" > "/data/data/com.termux/files/usr/tmp/gh_push.txt"
          else
             echo "GIT_PUSH_FAILED" > "/data/data/com.termux/files/usr/tmp/gh_push.txt"
          fi 
       fi   
    fi   
 fi
#----------------------------------------------------------------------------#
