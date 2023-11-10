#!/usr/bin/env bash

# Install (Recommended)
# eget "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream_segfault.sh" --to "$HOME/.data/scrape_certs_certstream_segfault" && chmod +xwr "$HOME/.data/scrape_certs_certstream_segfault" 
# bash "$HOME/.data/scrape_certs_certstream_segfault"
# Run (Install Less)
# bash <(curl -qfsSL "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream_segfault.sh")

# Time
START_TIME=$(date +%s)

# For debug
# set -x

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
   find "/tmp" -maxdepth 1 -name '*certstream*' -exec rm {} -rf \; 2>/dev/null
   find "/tmp" -maxdepth 1 -name '*Automata*' -exec rm {} -rf \; 2>/dev/null
   find "/tmp" -maxdepth 1 -name '*.log' -exec rm {} -rf \; 2>/dev/null
   find "/tmp" -maxdepth 1 -name '*.md' -exec rm {} -rf \; 2>/dev/null
   find "/tmp" -maxdepth 1 -name '*.txt' -exec rm {} -rf \; 2>/dev/null
   find "/tmp" -maxdepth 1 -name '*.7z' -exec rm {} -rf \; 2>/dev/null
   find "/tmp" -maxdepth 1 -name '*.zip' -exec rm {} -rf \; 2>/dev/null
  }
 #Export
 export -f kill_stale_procs
#Run Script
  kill_stale_procs
#----------------------------------------------------------------------------#
#Setup Dirs
mkdir -p "$HOME/bin"
export PATH="$HOME/bin:$PATH"
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
# echo $HOME --> /sec/root
if [ ! -d "/sec/root/CertStream-Domains" ]; then
      pushd "$HOME" && git clone "https://$CERTSTREAM_REPO_USER:$CERTSTREAM_REPO_TOKEN@github.com/Azathothas/CertStream-Domains.git"
      cd "./CertStream-Domains" && CERTSTREAM_REPO="$(realpath .)" ; export CERTSTREAM_REPO="$CERTSTREAM_REPO" ; popd 
else
      pushd "$HOME/CertStream-Domains" ; git fetch origin && git reset --hard origin/main ; git checkout HEAD -- ; git pull origin main
      CERTSTREAM_REPO="$(realpath .)" ; export CERTSTREAM_REPO="$CERTSTREAM_REPO" ; popd
fi
# HOST_IP | REGION
HOST_IP="$(curl --ipv4 -qfskSL http://ipv4.whatismyip.akamai.com | sed 's/[[:space:]]*$//' )" && export HOST_IP="$HOST_IP"
HOST_REGION="$(curl --ipv4 -qfskSL "http://ip-api.com/json/" | jq -r '"\(.country | gsub(" "; "-"))-\(.city | gsub(" "; "-"))"')" && export HOST_REGION="$HOST_REGION"
# Generate Initial Body for TG_BOT
# Create Markdown Body : https://core.telegram.org/bots/api#markdownv2-style
 # Assume archey is installed
 if command -v "archey" &>/dev/null; then
   # When piped to STDOUT, archey strips ansii colors
    archey 2>/dev/null | ansi2txt | tee "/tmp/archey.log"
 else
   # Use Pure Bash neoFetch
    echo -e "\nHostname: $(hostname)\nUser: $(whoami) $([ "$EUID" -ne 0 ] && echo '(NOT root)' || echo '(root)')\nSudo: $(command -v sudo >/dev/null 2>&1 && echo 'Installed' || echo 'Not Installed/Available')\nUptime: $(uptime -p 2>/dev/null || uptime | awk '{sub(/,$/, "", $3); print $3}')\nOS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | sed 's/"//g') ($(cat /etc/os-release | grep ID_LIKE | cut -d= -f2 | sed 's/"//g'))\nArchitecture: $(uname -m)\nKernel: $(uname -r)\nPackage Manager: $(cmds=$(for cmd in apk apt brew conda dnf emerge eopkg flatpak guix installer nix pacman pacman4 pisi pkg pkgutil port snap swupd tdnf xbps yum zypper; do command -v "$cmd" >/dev/null && printf "%s," "$cmd"; done) ; echo "${cmds%,}")\nSystem: $(ps -p 1 -o comm=)\nShell: $(echo "$SHELL")\nCPU: $(grep -c ^processor /proc/cpuinfo) x $(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 ) @ $(grep -m1 "cpu MHz" /proc/cpuinfo | cut -d: -f2 | tr -d '[:space:]') MHz\nRAM: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')\nDisk: $(df -h 2>/dev/null | awk '/^\/dev\// {if (line) line = line " | "; line = line $1"("$6")" " " $3 "/" $2 " (" $5 " used)"} END {print line}')\nIPv4: $(curl -qfsSL "http://ipv4.whatismyip.akamai.com" 2>/dev/null || echo 'Failed, Maybe no Curl?')\n" | tee "/tmp/archey.log"
 fi  
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#Run
#Banner
echo '```console' > "/tmp/BANNER.md"
cat << "EOF" | tee -a "/tmp/BANNER.md"
           _.====.._
         ,:._       ~-_
             `\        ~-_
               | _  _  |  `.
             ,/ /_)/ | |    ~-_
    -..__..-''  \_ \_\ `_      ~~-
           |~~Certs=Sream~~|
EOF
echo '```' >> "/tmp/BANNER.md"
echo -e "\n"
#Run
# ~ 50 K Subs --> 1MB
# Runs for 6.0 H (+ 40 Mins) | 400 Mins
 #timeout -k 1m 400m certstream --full --json | jq -r '.data.leaf_cert.all_domains[]' > "/tmp/certstream_domains.txt"
 echo -e "\n [+] Streaming...\n"
 timeout -k 1m 402m certstream > "/tmp/certstream_domains.txt"
#Filter & Parse
 #Remove Spaces
  sed -E '/^[[:space:]]*$/d' -i "/tmp/certstream_domains.txt"
 #Remove Wildcard
  sed 's/^\*\.\(.*\)/\1/; s/^\*//' -i "/tmp/certstream_domains.txt"
 #To Lowercase
  sed 's/[A-Z]/\L&/g' -i "/tmp/certstream_domains.txt"
 #Remove spaces v2.0
  sed 's/^[[:space:]]*//;s/[[:space:]]*$//' -i "/tmp/certstream_domains.txt"
#Sort
 sort -u "/tmp/certstream_domains.txt" -o "/tmp/certstream_domains.txt"
 #TG-BOT
 TOTAL_SUBSTREAMED_SUBS="$(wc -l < /tmp/certstream_domains.txt)" && export TOTAL_SUBSTREAMED_SUBS="$TOTAL_SUBSTREAMED_SUBS" ; echo "TOTAL_SUBSTREAMED_SUBS: $TOTAL_SUBSTREAMED_SUBS"
 SUBSTREAM_SIZE="$(du -h /tmp/certstream_domains.txt | awk '{print $1}')" && export SUBSTREAM_SIZE="$SUBSTREAM_SIZE" ; echo "SUBSTREAM_SIZE: $SUBSTREAM_SIZE"
# 7zip
 7z a -r -t7z -mx="9" -mmt="$(($(nproc)+1))" "/tmp/certstream_domains.7z" "/tmp/certstream_domains.txt" 2>/dev/null
 sha256sum "/tmp/certstream_domains.7z"
 SUBSTREAM_ARCHIVE_SIZE="$(du -h /tmp/certstream_domains.7z | awk '{print $1}')" && export SUBSTREAM_ARCHIVE_SIZE="$SUBSTREAM_ARCHIVE_SIZE" ; echo "SUBSTREAM_ARCHIVE_SIZE: $SUBSTREAM_ARCHIVE_SIZE"
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
# Time meth
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
ELAPSED_TIME_MINUTES=$((ELAPSED_TIME / 60))
ELAPSED_TIME_HOURS=$((ELAPSED_TIME / 3600))
START_TIME_NPT=$(TZ="Asia/Kathmandu" date -d "@$START_TIME" "+%Y-%m-%d %I:%M:%S %p Nepal TIME")
END_TIME_NPT=$(TZ="Asia/Kathmandu" date -d "@$END_TIME" "+%Y-%m-%d %I:%M:%S %p Nepal TIME")
# Create Body For TG_BOT
echo '```mathematica' > "/tmp/INVENTORY_TIME.md"
echo -e "Time Stats:" >> "/tmp/INVENTORY_TIME.md"
echo -e "Started At: $START_TIME_NPT" >> "/tmp/INVENTORY_TIME.md"
echo -e "Finished At: $END_TIME_NPT" >> "/tmp/INVENTORY_TIME.md"
echo -e "[Seconds: $ELAPSED_TIME]" >> "/tmp/INVENTORY_TIME.md"
echo -e "[Minutes: $ELAPSED_TIME_MINUTES]" >> "/tmp/INVENTORY_TIME.md"
echo -e "[Hours: $ELAPSED_TIME_HOURS]" >> "/tmp/INVENTORY_TIME.md"
echo '```' >> "/tmp/INVENTORY_TIME.md"
#----------------------------------------------------------------------------# 

#----------------------------------------------------------------------------#
# Inventory Bot
tgbot_push_success()
{
  # Generate Host Details
    echo -e "*Job* : 🌊 Substream Scrape SSL/TLS Certs ➼ (Segfault)" > "/tmp/INVENTORY_TG_BOT.md"
    echo -e "*Cluster* : Polaris 💫" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "*SegFault* : 🎏 [$SF_HOSTNAME]($SF_FQDN)\n" >> "/tmp/INVENTORY_TG_BOT.md"
   #Add Banner
    echo -e "$(cat /tmp/BANNER.md)\n" >> "/tmp/INVENTORY_TG_BOT.md"
   #Substream Stats
    echo -e '```console' >> "/tmp/INVENTORY_TG_BOT.md" 
    echo -e "\n[+] Substream Stats:" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "Total Certs Scraped: $TOTAL_SUBSTREAMED_SUBS" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "Size (TextFile): $SUBSTREAM_SIZE" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "Size (7z Archive): $SUBSTREAM_ARCHIVE_SIZE" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e '```' >> "/tmp/INVENTORY_TG_BOT.md"
   #Add Time 
    echo -e "$(cat /tmp/INVENTORY_TIME.md)\n" >> "/tmp/INVENTORY_TG_BOT.md"
   #Add Host Metadata 
    echo -e '```console' >> "/tmp/INVENTORY_TG_BOT.md" 
    echo -e "[+] Origin Traffic: $HOST_IP ($HOST_REGION)" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "[+] Host Metadata:\n" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "$(cat /tmp/archey.log)" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e '```' >> "/tmp/INVENTORY_TG_BOT.md"
    #Add Storage 
    echo -e '```mathematica' >> "/tmp/INVENTORY_TG_BOT.md"
    #curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/duf" -o "$HOME/bin/duf" && chmod +xwr "$HOME/bin/duf"
    echo -e "[+] Storage:\n" >> "/tmp/INVENTORY_TG_BOT.md"
    duf "/sec" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e '```' >> "/tmp/INVENTORY_TG_BOT.md"
    #Add bandwidth
    echo -e '```mathematica' >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "\n[+] Bandwidth:\n" >> "/tmp/INVENTORY_TG_BOT.md"
    ip -s -h link show eth0 | grep -i "RX" -A 5 >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e '```' >> "/tmp/INVENTORY_TG_BOT.md"
   # Denote Status && Add to /tmp/INVENTORY_TG_BOT.md
    echo "✅ *Successfully* _Pushed_ ➼ [CertStream-Domains](https://github.com/Azathothas/CertStream-Domains)" >> "/tmp/INVENTORY_TG_BOT.md"
    echo "📔 _View Commit Detail_ : [Commits](https://github.com/Azathothas/CertStream-Domains/commits/main)" >> "/tmp/INVENTORY_TG_BOT.md"
    echo "📔 _View Changes_ : [Raw/Latest](https://github.com/Azathothas/CertStream-Domains/blob/main/Raw/Latest/)" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "*$(cat /tmp/gh_push.txt)*" >> /tmp/INVENTORY_TG_BOT.md
   # Send Notification To TG
    apprise "tgram://$INVENTORY_TG_BOT/?format=markdown" -vv -t "@$GH_USER" -b "$(cat /tmp/INVENTORY_TG_BOT.md)"
}
export -f tgbot_push_success
tgbot_push_failed()
{
  # Generate Host Details
    echo -e "*Job* : 🌊 Substream Scrape SSL/TLS Certs ➼ (Segfault)" > "/tmp/INVENTORY_TG_BOT.md"
    echo -e "*Cluster* : Polaris 💫" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "*SegFault* : 🎏 [$SF_HOSTNAME]($SF_FQDN)\n" >> "/tmp/INVENTORY_TG_BOT.md"
   #Add Banner
    echo -e "$(cat /tmp/BANNER.md)\n" >> "/tmp/INVENTORY_TG_BOT.md"
   #Substream Stats
    echo -e '```console' >> "/tmp/INVENTORY_TG_BOT.md" 
    echo -e "\n[+] Substream Stats:" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "Total Certs Scraped: $TOTAL_SUBSTREAMED_SUBS" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "Size (TextFile): $SUBSTREAM_SIZE" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "Size (7z Archive): $SUBSTREAM_ARCHIVE_SIZE" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e '```' >> "/tmp/INVENTORY_TG_BOT.md"
   #Add Time 
    echo -e "$(cat /tmp/INVENTORY_TIME.md)\n" >> "/tmp/INVENTORY_TG_BOT.md"
   #Add Host Metadata 
    echo -e '```console' >> "/tmp/INVENTORY_TG_BOT.md" 
    echo -e "[+] Origin Traffic: $HOST_IP ($HOST_REGION)" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "[+] Host Metadata:\n" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "$(cat /tmp/archey.log)" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e '```' >> "/tmp/INVENTORY_TG_BOT.md"
    #Add Storage 
    echo -e '```mathematica' >> "/tmp/INVENTORY_TG_BOT.md"
    #curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/duf" -o "$HOME/bin/duf" && chmod +xwr "$HOME/bin/duf"
    echo -e "[+] Storage:\n" >> "/tmp/INVENTORY_TG_BOT.md"
    duf "/sec" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e '```' >> "/tmp/INVENTORY_TG_BOT.md"
    #Add bandwidth
    echo -e '```mathematica' >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "\n[+] Bandwidth:\n" >> "/tmp/INVENTORY_TG_BOT.md"
    ip -s -h link show eth0 | grep -i "RX" -A 5 >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e '```' >> "/tmp/INVENTORY_TG_BOT.md"
   # Denote Status && Add to /tmp/INVENTORY_TG_BOT.md
    echo "❌ *Failed* _Git Push_ ➼ [CertStream-Domains](https://github.com/Azathothas/CertStream-Domains)" >> "/tmp/INVENTORY_TG_BOT.md"
    echo -e "*$(cat /tmp/gh_push.txt)*" >> "/tmp/INVENTORY_TG_BOT.md"
   # Send Notification To TG
    apprise "tgram://$INVENTORY_TG_BOT/?format=markdown" -vv -t "@$GH_USER" -b "$(cat /tmp/INVENTORY_TG_BOT.md)"
}
export -f tgbot_push_failed
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------# 
#GitOps
#Git Pull
 pushd "$CERTSTREAM_REPO" && git pull origin main ; popd   
#Add To Repo
 mkdir -p "$CERTSTREAM_REPO/Raw/Latest"
 SAFE_END_TIME_NPT="$(echo $END_TIME_NPT | sed 's/[ -]/_/g; s/:/_/g')"
 cp "/tmp/certstream_domains.7z" "$CERTSTREAM_REPO/Raw/Latest/certstream_$SAFE_END_TIME_NPT.7z" 
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
 git commit -m "Segfault ($HOST_IP) --> CertStreamed SSL|TLS Certs ($SF_HOSTNAME)" 
# Pull one last time
 git config --global pull.rebase true
 git pull origin main
# Finally push 
 # Try pushing
 if git push -u origin main; then
    echo "GIT_PUSH_PASSED" > "/tmp/gh_push.txt"
    tgbot_push_success
 else
    #we fucked up
    echo "GIT_PUSH_FAILED" > "/tmp/gh_push.txt"
    echo "GIT_PUSH_FAILED=true" >> $GITHUB_ENV 2>/dev/null
    #Wait few mins
    sleep 120
    git config --global pull.rebase true
    git pull origin main
    # Check again
    if git push -u origin main; then
       echo "GIT_PUSH_PASSED" > "/tmp/gh_push.txt"
       tgbot_push_success
    else
       sleep 200
       if git push -u origin main; then
          echo "GIT_PUSH_PASSED" > "/tmp/gh_push.txt"
          tgbot_push_success
       else
          git config pull.rebase false
          git pull origin main --no-edit
          if git push -u origin main; then
             echo "GIT_PUSH_PASSED" > "/tmp/gh_push.txt"
             tgbot_push_success
          else
             echo "GIT_PUSH_FAILED" > "/tmp/gh_push.txt"
             tgbot_push_failed
          fi 
       fi   
    fi   
 fi
#----------------------------------------------------------------------------#
