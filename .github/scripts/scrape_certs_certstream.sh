#!/usr/bin/env bash

# Install (Recommended)
# eget "https://${CERTSTREAM_REPO_USER}:${CERTSTREAM_REPO_TOKEN}@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream.sh" --to "$HOME/.data/scrape_certs_certstream" && chmod +xwr "$HOME/.data/scrape_certs_certstream" 
# bash "$HOME/.data/scrape_certs_certstream"
# Run (Install Less)
# bash <(curl -qfsSL -A "$USER_AGENT" "https://${CERTSTREAM_REPO_USER}:${CERTSTREAM_REPO_TOKEN}@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/scrape_certs_certstream.sh")


#----------------------------------------------------------------------------#
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

#----------------------------------------------------------------------------#
#Setup Dirs & Env
# ENV:VARS (Read from $ENV)
#CERTSTREAM_REPO_USER
#CERTSTREAM_REPO_TOKEN
mkdir -p "${HOME}/bin" "${HOME}/.local/bin"
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
SYSTMP="$(dirname $(mktemp -u))" && export SYSTMP="${SYSTMP}"
USER_AGENT="$(curl -qfsSL 'https://pub.ajam.dev/repos/Azathothas/Wordlists/Misc/User-Agents/ua_chrome_macos_latest.txt')" && export USER_AGENT="${USER_AGENT}" 
CERTSTREAM_TMPDIR="${SYSTMP}/Certstream.tmp" && mkdir -p "${CERTSTREAM_TMPDIR}" ; export CERTSTREAM_TMPDIR="${CERTSTREAM_TMPDIR}"
export CERTSTREAM_OUT="${CERTSTREAM_TMPDIR}/certstream_domains.txt"
export CERTSTREAM_7Z="${CERTSTREAM_TMPDIR}/certstream_domains.7z"
export CERTSTREAM_RAWOUT="${CERTSTREAM_TMPDIR}/certstream_domains_raw.txt"
export CERTSTREAM_REPODIR="${CERTSTREAM_TMPDIR}/CertStream-Domains"
export GIT_TERMINAL_PROMPT="0"
export GIT_ASKPASS="/bin/echo"
#commit msg :: "${HOST_RUNNER} (${HOST_NAME}) --> CertStreamed SSL|TLS Certs"
#HOST_IP | REGION
HOST_IP="$(curl --ipv4 -qfskSL -A "$USER_AGENT" "http://ipv4.whatismyip.akamai.com" | sed 's/[[:space:]]*$//' )" && export HOST_IP="${HOST_IP}"
HOST_IPV6="$(curl --ipv6 -qfskSL -A "$USER_AGENT" "http://ipv6.whatismyip.akamai.com" 2>/dev/null | sed 's/[[:space:]]*$//' )" && export HOST_IPV6="${HOST_IPV6}"
HOST_REGION="$(curl --ipv4 -qfskSL -A "$USER_AGENT" "http://ip-api.com/json/" | jq -r '"\(.country | gsub(" "; "-"))-\(.city | gsub(" "; "-"))"')" && export HOST_REGION="${HOST_REGION}"
export HOST_RUNNER="🌊 [${HOST_REGION}]"
export HOST_NAME="u$(< /dev/urandom tr -dc '0-9' | head -c 4)-Streamer"
#IP Interface
BW_INTERFACE="$(ip route | grep -i 'default' | awk '{print $5}' | tr -d '[:space:]')" && export BW_INTERFACE="${BW_INTERFACE}"
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#Kill Stale Processes
kill_stale_procs()
  {
  #procs
   pgrep -f inscope | xargs kill -9 2>/dev/null
   #Files 
   find "${CERTSTREAM_TMPDIR}" -maxdepth 1 -name '*certstream*' -exec rm {} -rf \; 2>/dev/null
   find "${CERTSTREAM_TMPDIR}" -maxdepth 1 -name '*Automata*' -exec rm {} -rf \; 2>/dev/null
   find "${CERTSTREAM_TMPDIR}" -maxdepth 1 -name '*.log' -exec rm {} -rf \; 2>/dev/null
   find "${CERTSTREAM_TMPDIR}" -maxdepth 1 -name '*.md' -exec rm {} -rf \; 2>/dev/null
   find "${CERTSTREAM_TMPDIR}" -maxdepth 1 -name '*.txt' -exec rm {} -rf \; 2>/dev/null
   find "${CERTSTREAM_TMPDIR}" -maxdepth 1 -name '*.yaml' -exec rm {} -rf \; 2>/dev/null
   find "${CERTSTREAM_TMPDIR}" -maxdepth 1 -name '*.yml' -exec rm {} -rf \; 2>/dev/null
   find "${CERTSTREAM_TMPDIR}" -maxdepth 1 -name '*.7z' -exec rm {} -rf \; 2>/dev/null
   find "${CERTSTREAM_TMPDIR}" -maxdepth 1 -name '*.zip' -exec rm {} -rf \; 2>/dev/null
  }
 #Export
 export -f kill_stale_procs
#Run Script
  kill_stale_procs
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#Repo Setup
GH_USER="${CERTSTREAM_REPO_USER}" && export GH_USER="$GH_USER"
export GITHUB_TOKEN="${CERTSTREAM_REPO_TOKEN}"
#Setup Repo
if [ ! -d "${CERTSTREAM_REPODIR}" ]; then
      pushd "${CERTSTREAM_TMPDIR}" >/dev/null 2>&1 && git clone --filter="blob:none" "https://${CERTSTREAM_REPO_USER}:${CERTSTREAM_REPO_TOKEN}@github.com/Azathothas/CertStream-Domains.git"
      cd "./CertStream-Domains" && CERTSTREAM_REPO="$(realpath .)" ; export CERTSTREAM_REPO="${CERTSTREAM_REPO}" ; popd >/dev/null 2>&1
else
    #Check if git is too bloated
     if [ -d "${CERTSTREAM_REPO}/.git" ] && [ "$(du -sk ${CERTSTREAM_REPO}/.git | cut -f1)" -ge "7000000" ]; then
         echo -e "\n[+] ${CERTSTREAM_REPO}/.git exceeds 7.0 GB\n"
         #Purge
         rm -rf "${CERTSTREAM_REPO}" 2>/dev/null
         #re(Clone)
         pushd "${CERTSTREAM_TMPDIR}" >/dev/null 2>&1 && git clone --filter="blob:none" --quiet "https://${CERTSTREAM_REPO_USER}:${CERTSTREAM_REPO_TOKEN}@github.com/Azathothas/CertStream-Domains.git"
         #Export PATH
         cd "./CertStream-Domains" && CERTSTREAM_REPO="$(realpath .)" ; export CERTSTREAM_REPO="${CERTSTREAM_REPO}" ; popd >/dev/null 2>&1
    else
         pushd "${CERTSTREAM_REPODIR}" >/dev/null 2>&1 ; git fetch origin && git reset --hard "origin/main" ; git checkout HEAD -- ; git pull origin main --no-edit 2>/dev/null
         CERTSTREAM_REPO="$(realpath .)" ; export CERTSTREAM_REPO="${CERTSTREAM_REPO}" ; popd >/dev/null 2>&1
    fi
fi
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
# Generate Initial Body for TG_BOT
# Create Markdown Body : https://core.telegram.org/bots/api#markdownv2-style
 # Assume archey is installed
 if command -v "archey" &>/dev/null; then
   # When piped to STDOUT, archey strips ansii colors
    archey 2>/dev/null | ansi2txt 2>/dev/null | tee "${SYSTMP}/archey.log"
 else
   # Use Pure Bash neoFetch
    echo -e "\nHostname: $(hostname)\nUser: $(whoami) $([ "$EUID" -ne 0 ] && echo '(NOT root)' || echo '(root)')\nSudo: $(command -v sudo >/dev/null 2>&1 && echo 'Installed' || echo 'Not Installed/Available')\nUptime: $(uptime -p 2>/dev/null || uptime | awk '{sub(/,$/, "", $3); print $3}')\nOS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | sed 's/"//g') ($(cat /etc/os-release | grep ID_LIKE | cut -d= -f2 | sed 's/"//g'))\nArchitecture: $(uname -m)\nKernel: $(uname -r)\nPackage Manager: $(cmds=$(for cmd in apk apt brew conda dnf emerge eopkg flatpak guix installer nix pacman pacman4 pisi pkg pkgutil port snap swupd tdnf xbps yum zypper; do command -v "$cmd" >/dev/null && printf "%s," "$cmd"; done) ; echo "${cmds%,}")\nSystem: $(ps -p 1 -o comm=)\nShell: $(echo "$SHELL")\nCPU: $(grep -c ^processor /proc/cpuinfo) x $(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 ) @ $(grep -m1 "cpu MHz" /proc/cpuinfo | cut -d: -f2 | tr -d '[:space:]') MHz\nRAM: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')\nDisk: $(df -h 2>/dev/null | awk '/^\/dev\// {if (line) line = line " | "; line = line $1"("$6")" " " $3 "/" $2 " (" $5 " used)"} END {print line}')\nIPv4: $(curl -qfsSL -A "$USER_AGENT" "http://ipv4.whatismyip.akamai.com" 2>/dev/null || echo 'Failed, Maybe no Curl?')\n" | tee "${SYSTMP}/archey.log"
 fi
 #Remove IP Addrs
  sed "s/${HOST_IP}/127.0.0.1/" -i "${SYSTMP}/archey.log" ; export HOST_IP="127.0.0.1"
  sed "s/${HOST_IPV6}/::1/" -i "${SYSTMP}/archey.log" ; export HOST_IPV6="::1"
  sed '/.*LAN.*IP.*/d; /.*WAN.*IP.*/d' -i "${SYSTMP}/archey.log"
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
##Run
#Banner
echo '```console' > "${SYSTMP}/BANNER.md"
cat << "EOF" | tee -a "${SYSTMP}/BANNER.md"
           _.====.._
         ,:._       ~-_
             `\        ~-_
               | _  _  |  `.
             ,/ /_)/ | |    ~-_
    -..__..-''  \_ \_\ `_      ~~-
           |~~Certs=Sream~~|
EOF
echo '```' >> "${SYSTMP}/BANNER.md"
echo -e "\n"
##StreamTime
if [ -z "$STREAM_TIME" ]; then
    echo -e "\n [+] Streaming... for 250m\n"
    export STREAM_TIME="250m"
else
    echo -e "\n [+] Streaming... for $STREAM_TIME\n"
fi
##Run
echo "$(date --utc +'%H:%M:%S %Z (%a %b %-d, %Y)') || $(TZ='Asia/Kathmandu' date +'%H:%M:%S %Z (%a %b %-d, %Y)')"
 #Configure certstream-server-go
   #kill zombie server
    pgrep -f "certstream-server-go" | xargs kill -9 2>/dev/null
    rm "${CERTSTREAM_TMPDIR}/server_config.yaml" 2>/dev/null
   #Get Latest Config
    wget --quiet --show-progress --progress="dot:giga" "https://pub.ajam.dev/repos/Azathothas/Arsenal/certstream/server_config.yaml" -O "${CERTSTREAM_TMPDIR}/server_config.yaml"
 #Start Server
 nohup certstream-server-go -config "${CERTSTREAM_TMPDIR}/server_config.yaml" >/dev/null 2>&1 &
 #Start client
 # DO NOT USE -output, instead rely on >> or tee
 rm -rf "${CERTSTREAM_RAWOUT}" 2>/dev/null
 nohup certstream -url "ws://localhost:8888" -domains-only -quiet >> "${CERTSTREAM_RAWOUT}" 2>&1 &
 #timeout -k 1m "$STREAM_TIME" certstream -url "ws://localhost:8888" -domains-only -quiet > "${CERTSTREAM_RAWOUT}"
 #timeout -k 1m "$STREAM_TIME" certstream -url "wss://certstream.calidog.io" -domains-only -quiet > "${CERTSTREAM_OUT}"
#Loop
while true; do
 START_TIME="$(date +%s)"
 #Sleep & wait
  #sleep "$STREAM_TIME"
  #timeout -k 1m "$STREAM_TIME" yes >/dev/null
  timeout -k 1m "$STREAM_TIME" sh -c 'tail -f /dev/null' >/dev/null
  echo "$(date --utc +'%H:%M:%S %Z (%a %b %-d, %Y)') || $(TZ='Asia/Kathmandu' date +'%H:%M:%S %Z (%a %b %-d, %Y)')"
 #Filter & Parse
  #Fetch first 1M Lines
   pgrep -f cutlines | xargs kill -9 2>/dev/null
   cutlines --lines 10000000 --file "${CERTSTREAM_RAWOUT}" --output "${CERTSTREAM_OUT}"
   if [[ "$(file -b --mime-type ${CERTSTREAM_RAWOUT})" != "text/plain" && "$(file -b --mime-type ${CERTSTREAM_RAWOUT})" != "inode/x-empty" ]]; then
      echo -e "\n[+] FATAL: ${CERTSTREAM_RAWOUT} seems to be Corrupted ($(file -b --mime-type "${CERTSTREAM_RAWOUT}"))\n"
     exit 1
   fi
   if [[ "$(file -b --mime-type ${CERTSTREAM_OUT})" != "text/plain" && "$(file -b --mime-type ${CERTSTREAM_OUT})" != "inode/x-empty" ]]; then
      echo -e "\n[+] FATAL: ${CERTSTREAM_OUT} seems to be Corrupted ($(file -b --mime-type "${CERTSTREAM_OUT}"))\n"
     exit 1 
   fi
  #Remove Spaces
   sed -E '/^[[:space:]]*$/d' -i "${CERTSTREAM_OUT}"
  #Remove Wildcard
   sed 's/^\*\.\(.*\)/\1/; s/^\*//' -i "${CERTSTREAM_OUT}"
  #To Lowercase
   sed 's/[A-Z]/\L&/g' -i "${CERTSTREAM_OUT}"
  #Remove spaces v2.0
   sed 's/^[[:space:]]*//;s/[[:space:]]*$//' -i "${CERTSTREAM_OUT}"
  #Remove `:`
   sed -i '/:/d' "${CERTSTREAM_OUT}"
 #Sort
  sort -u "${CERTSTREAM_OUT}" -o "${CERTSTREAM_OUT}"
  #TG-BOT
  TOTAL_SUBSTREAMED_SUBS="$(wc -l < ${CERTSTREAM_OUT})" && export TOTAL_SUBSTREAMED_SUBS="$TOTAL_SUBSTREAMED_SUBS" ; echo "TOTAL_SUBSTREAMED_SUBS: $TOTAL_SUBSTREAMED_SUBS"
  SUBSTREAM_SIZE="$(du -h ${CERTSTREAM_OUT} | awk '{print $1}')" && export SUBSTREAM_SIZE="$SUBSTREAM_SIZE" ; echo "SUBSTREAM_SIZE: $SUBSTREAM_SIZE"
 #7zip
  7z a -r -t7z -mx="9" -mmt="$(($(nproc)+1))" "${CERTSTREAM_7Z}" "${CERTSTREAM_OUT}" 2>/dev/null
  sha256sum "${CERTSTREAM_7Z}"
  SUBSTREAM_ARCHIVE_SIZE="$(du -h ${CERTSTREAM_7Z} | awk '{print $1}')" && export SUBSTREAM_ARCHIVE_SIZE="${SUBSTREAM_ARCHIVE_SIZE}" ; echo "SUBSTREAM_ARCHIVE_SIZE: ${SUBSTREAM_ARCHIVE_SIZE}"
 #cleanup
  rm "${CERTSTREAM_OUT}" 2>/dev/null
 #----------------------------------------------------------------------------#
 
 #----------------------------------------------------------------------------#
 # Time meth
 END_TIME="$(date +%s)"
 ELAPSED_TIME="$(date -u -d@"$((END_TIME - START_TIME))" "+%H(Hr):%M(Min):%S(Sec)")"
 START_TIME_NPT="$(TZ="Asia/Kathmandu" date -d "@$START_TIME" "+%Y-%m-%d %I:%M:%S %p Nepal TIME")"
 END_TIME_NPT="$(TZ="Asia/Kathmandu" date -d "@$END_TIME" "+%Y-%m-%d %I:%M:%S %p Nepal TIME")"
 # Create Body For TG_BOT
 echo '```mathematica' > "${SYSTMP}/INVENTORY_TIME.md"
 echo -e "Time Stats:" >> "${SYSTMP}/INVENTORY_TIME.md"
 echo -e "Started At: $START_TIME_NPT" >> "${SYSTMP}/INVENTORY_TIME.md"
 echo -e "Finished At: $END_TIME_NPT" >> "${SYSTMP}/INVENTORY_TIME.md"
 echo -e "Runtime: $ELAPSED_TIME]" >> "${SYSTMP}/INVENTORY_TIME.md"
 echo '```' >> "${SYSTMP}/INVENTORY_TIME.md"
 #----------------------------------------------------------------------------# 
 
 #----------------------------------------------------------------------------#
 #Server Meta
 mkdir -p "${CERTSTREAM_REPO}/.github/SERVERS"
 { echo -e "\n[+] Metadata" ; archey 2>/dev/null | ansi2txt ; echo -e "[+] Storage:\n" ; duf "/" ; echo -e "\n[+] BandWidth" ; ip -s -h link show eth0 | grep -i "RX" -A 5 ; echo ""; } | tee "${CERTSTREAM_REPO}/.github/SERVERS/$HOSTNAME-meta.txt"
 #Remove IP Addrs
  sed "s/${HOST_IP}/127.0.0.1/" -i "${CERTSTREAM_REPO}/.github/SERVERS/$HOSTNAME-meta.txt" ; export HOST_IP="127.0.0.1"
  sed "s/${HOST_IPV6}/::1/" -i "${CERTSTREAM_REPO}/.github/SERVERS/$HOSTNAME-meta.txt" ; export HOST_IPV6="::1"
  sed '/.*LAN.*IP.*/d; /.*WAN.*IP.*/d' -i "${CERTSTREAM_REPO}/.github/SERVERS/$HOSTNAME-meta.txt"
 #----------------------------------------------------------------------------#
 
 #----------------------------------------------------------------------------#
 # Inventory Bot
 tgbot_push_success()
 {
   # Generate Host Details
     echo -e "*Job* : 🌊 Substream Scrape SSL/TLS Certs ➼ (${HOST_RUNNER})" > "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "*Cluster* : Polaris 💫" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
    #Add Banner
     echo -e "$(cat ${SYSTMP}/BANNER.md)\n" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
    #Substream Stats
     echo -e '```console' >> "${SYSTMP}/INVENTORY_TG_BOT.md" 
     echo -e "\n[+] Substream Stats:" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "Total Certs Scraped: $TOTAL_SUBSTREAMED_SUBS" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "Size (TextFile): $SUBSTREAM_SIZE" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "Size (7z Archive): ${SUBSTREAM_ARCHIVE_SIZE}" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e '```' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
    #Add Time 
     echo -e "$(cat ${SYSTMP}/INVENTORY_TIME.md)\n" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
    #Add Host Metadata 
     echo -e '```console' >> "${SYSTMP}/INVENTORY_TG_BOT.md" 
     echo -e "[+] Origin Traffic: ${HOST_IP} (${HOST_REGION})" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "[+] Host Metadata:\n" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "$(cat ${SYSTMP}/archey.log)" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e '```' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     #Add Storage 
     echo -e '```mathematica' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     #curl -qfsSL -A "$USER_AGENT" "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/duf" -o "$HOME/bin/duf" && chmod +xwr "$HOME/bin/duf"
     echo -e "[+] Storage:\n" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     duf "/" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e '```' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     #Add bandwidth
     if command -v vnstat &> /dev/null && [ -s "/etc/vnstat.conf" ] && [ -s "/var/lib/vnstat/vnstat.db" ] && pgrep vnstat > /dev/null; then
           echo -e '```mathematica' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
           echo -e "\n[+] Bandwidth:\n" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
           vnstat --iface "${BW_INTERFACE}" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
           echo -e '```' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     else
           echo -e '```mathematica' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
           echo -e "\n[+] Bandwidth:\n" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
           ip -s -h link show "${BW_INTERFACE}" | grep -i "RX" -A 5 | grep -iv 'altname' | sed '/^[[:space:]]*$/d' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
           echo -e '```' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     fi
    # Denote Status && Add to ${SYSTMP}/INVENTORY_TG_BOT.md
     echo "✅ *Successfully* _Pushed_ ➼ [CertStream-Domains](https://github.com/Azathothas/CertStream-Domains)" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo "📔 _View Commit Detail_ : [Commits](https://github.com/Azathothas/CertStream-Domains/commits/main)" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo "📔 _View Changes_ : [Raw/Latest](https://github.com/Azathothas/CertStream-Domains/blob/main/Raw/Latest/)" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "*$(cat ${SYSTMP}/gh_push.txt)*" >> ${SYSTMP}/INVENTORY_TG_BOT.md
    #Send Notification To TG
     freeze --execute "glow --style 'dracula' --width '120' '${SYSTMP}/INVENTORY_TG_BOT.md'" --language "markdown" --theme "dracula" --output "${SYSTMP}/INVENTORY_TG_BOT.png"
     apprise "tgram://$INVENTORY_TG_BOT/?format=markdown" -vv -t "@$GH_USER" -b "$(cat ${SYSTMP}/INVENTORY_TG_BOT.md)" || telegram-send --pre "$(cat ${SYSTMP}/INVENTORY_TG_BOT.md)" --image "${SYSTMP}/INVENTORY_TG_BOT.png" --showids
 }
 export -f tgbot_push_success
 tgbot_push_failed()
 {
   # Generate Host Details
     echo -e "*Job* : 🌊 Substream Scrape SSL/TLS Certs ➼ (${HOST_RUNNER})" > "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "*Cluster* : Polaris 💫" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
    #Add Banner
     echo -e "$(cat ${SYSTMP}/BANNER.md)\n" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
    #Substream Stats
     echo -e '```console' >> "${SYSTMP}/INVENTORY_TG_BOT.md" 
     echo -e "\n[+] Substream Stats:" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "Total Certs Scraped: $TOTAL_SUBSTREAMED_SUBS" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "Size (TextFile): $SUBSTREAM_SIZE" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "Size (7z Archive): ${SUBSTREAM_ARCHIVE_SIZE}" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e '```' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
    #Add Time 
     echo -e "$(cat ${SYSTMP}/INVENTORY_TIME.md)\n" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
    #Add Host Metadata 
     echo -e '```console' >> "${SYSTMP}/INVENTORY_TG_BOT.md" 
     echo -e "[+] Origin Traffic: ${HOST_IP} (${HOST_REGION})" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "[+] Host Metadata:\n" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "$(cat ${SYSTMP}/archey.log)" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e '```' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     #Add Storage 
     echo -e '```mathematica' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     #curl -qfsSL -A "$USER_AGENT" "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/duf" -o "$HOME/bin/duf" && chmod +xwr "$HOME/bin/duf"
     echo -e "[+] Storage:\n" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     duf "/" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e '```' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     #Add bandwidth
     if command -v vnstat &> /dev/null && [ -s "/etc/vnstat.conf" ] && [ -s "/var/lib/vnstat/vnstat.db" ] && pgrep vnstat > /dev/null; then
           echo -e '```mathematica' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
           echo -e "\n[+] Bandwidth:\n" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
           vnstat --iface "${BW_INTERFACE}" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
           echo -e '```' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     else
           echo -e '```mathematica' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
           echo -e "\n[+] Bandwidth:\n" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
           ip -s -h link show "${BW_INTERFACE}" | grep -i "RX" -A 5 | grep -iv 'altname' | sed '/^[[:space:]]*$/d' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
           echo -e '```' >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     fi
    # Denote Status && Add to ${SYSTMP}/INVENTORY_TG_BOT.md
     echo "❌ *Failed* _Git Push_ ➼ [CertStream-Domains](https://github.com/Azathothas/CertStream-Domains)" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
     echo -e "*$(cat ${SYSTMP}/gh_push.txt)*" >> "${SYSTMP}/INVENTORY_TG_BOT.md"
    #Send Notification To TG
     freeze --execute "glow --style 'dracula' --width '120' '${SYSTMP}/INVENTORY_TG_BOT.md'" --language "markdown" --theme "dracula" --output "${SYSTMP}/INVENTORY_TG_BOT.png"
     apprise "tgram://$INVENTORY_TG_BOT/?format=markdown" -vv -t "@$GH_USER" -b "$(cat ${SYSTMP}/INVENTORY_TG_BOT.md)" || telegram-send --pre "$(cat ${SYSTMP}/INVENTORY_TG_BOT.md)" --image "${SYSTMP}/INVENTORY_TG_BOT.png" --showids
 }
 export -f tgbot_push_failed
 #----------------------------------------------------------------------------#
 
 #----------------------------------------------------------------------------# 
 #GitOps
 #Git Pull
  pushd "${CERTSTREAM_REPO}" >/dev/null 2>&1 && git pull origin main --no-edit 2>/dev/null ; popd >/dev/null 2>&1   
 #Add To Repo
  mkdir -p "${CERTSTREAM_REPO}/Raw/Latest"
  SAFE_END_TIME_NPT="$(echo $END_TIME_NPT | sed 's/[ -]/_/g; s/:/_/g')"
  cp "${CERTSTREAM_7Z}" "${CERTSTREAM_REPO}/Raw/Latest/certstream_$SAFE_END_TIME_NPT.7z" 
 # chdir to Inventory
  cd "${CERTSTREAM_REPO}"
 # Add repo wise config
  git config "user.email" "AjamX101@gmail.com"
  git config "user.name" "Azathothas"
 # Pull to sync updates
  git config --global "pull.rebase" true
  git pull origin main --no-edit 2>/dev/null
 # Add everything
  git add --all --verbose
  git commit -m "${HOST_RUNNER} (${HOST_NAME}) --> CertStreamed SSL|TLS Certs"
 # Pull one last time
  git config --global "pull.rebase" true
  git pull origin main --no-edit 2>/dev/null
 # Finally push 
  # Try pushing
  if git push -u origin main; then
     echo "$(date --utc +'%H:%M:%S %Z (%a %b %-d, %Y)') || $(TZ='Asia/Kathmandu' date +'%H:%M:%S %Z (%a %b %-d, %Y)')"
     echo "GIT_PUSH_PASSED" > "${SYSTMP}/gh_push.txt"
     #tgbot_push_success
  else
     #we fucked up
     echo "$(date --utc +'%H:%M:%S %Z (%a %b %-d, %Y)') || $(TZ='Asia/Kathmandu' date +'%H:%M:%S %Z (%a %b %-d, %Y)')"
     echo "GIT_PUSH_FAILED" > "${SYSTMP}/gh_push.txt"
     echo "GIT_PUSH_FAILED=true" >> $GITHUB_ENV 2>/dev/null
     #Wait few mins
     sleep 120
     git config --global "pull.rebase" true
     git pull origin main --no-edit 2>/dev/null
     # Check again
     if git push -u origin main; then
        echo "$(date --utc +'%H:%M:%S %Z (%a %b %-d, %Y)') || $(TZ='Asia/Kathmandu' date +'%H:%M:%S %Z (%a %b %-d, %Y)')"
        echo "GIT_PUSH_PASSED" > "${SYSTMP}/gh_push.txt"
        #tgbot_push_success
     else
        sleep 200
        if git push -u origin main; then
           echo "$(date --utc +'%H:%M:%S %Z (%a %b %-d, %Y)') || $(TZ='Asia/Kathmandu' date +'%H:%M:%S %Z (%a %b %-d, %Y)')"
           echo "GIT_PUSH_PASSED" > "${SYSTMP}/gh_push.txt"
           #tgbot_push_success
           find "${CERTSTREAM_TMPDIR}" -maxdepth 1 -name '*.7z' -exec rm {} -rf \; 2>/dev/null
        else
           git config pull.rebase false
           git pull origin main --no-edit 2>/dev/null
           if git push -u origin main; then
              echo "$(date --utc +'%H:%M:%S %Z (%a %b %-d, %Y)') || $(TZ='Asia/Kathmandu' date +'%H:%M:%S %Z (%a %b %-d, %Y)')"
              echo "GIT_PUSH_PASSED" > "${SYSTMP}/gh_push.txt"
              #tgbot_push_success
              find "${CERTSTREAM_TMPDIR}" -maxdepth 1 -name '*.7z' -exec rm {} -rf \; 2>/dev/null
           else
              echo "$(date --utc +'%H:%M:%S %Z (%a %b %-d, %Y)') || $(TZ='Asia/Kathmandu' date +'%H:%M:%S %Z (%a %b %-d, %Y)')"
              echo "GIT_PUSH_FAILED" > "${SYSTMP}/gh_push.txt"
              #tgbot_push_failed
               #Reset 
                 echo -e "\n[+] Resetting ${CERTSTREAM_REPO} ....\n"
                 #Purge
                 rm -rf "${CERTSTREAM_REPO}" 2>/dev/null
                 #re(Clone)
                 pushd "${CERTSTREAM_TMPDIR}" >/dev/null 2>&1 && git clone --filter="blob:none" --quiet "https://${CERTSTREAM_REPO_USER}:${CERTSTREAM_REPO_TOKEN}@github.com/Azathothas/CertStream-Domains.git" ; popd >/dev/null 2>&1
           fi
        fi
     fi
  fi
 #----------------------------------------------------------------------------# 
done
pgrep -f cutlines | xargs kill -9 2>/dev/null
#----------------------------------------------------------------------------#
