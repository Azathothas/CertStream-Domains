#! /usr/bin/env bash

#Git Pull
 cd "$GITHUB_WORKSPACE/main" && git pull origin main 
#Resolvers
 curl -qfsSL "https://raw.githubusercontent.com/proabiral/Fresh-Resolvers/master/resolvers.ipv6" -o "/tmp/resolvers.txt"
 curl -qfsSL "https://raw.githubusercontent.com/edoardottt/secfiles/main/dns/trusted-resolvers-small.txt" | anew -q "/tmp/resolvers.txt"
 curl -qfsSL "https://raw.githubusercontent.com/trickest/resolvers/main/resolvers-trusted.txt" | anew -q "/tmp/resolvers.txt"
 sort -u "/tmp/resolvers.txt" -o "/tmp/resolvers.txt"
#---------------------# 
#HTTPx (General)
 httpx -l "$GITHUB_WORKSPACE/main/Data/np_ccTLDs/certstream_domains_np_all_24h.txt" -r "/tmp/resolvers.txt" -ip -status-code -title -location -follow-host-redirects -include-chain -server -tech-detect -cdn -content-type -content-length -websocket -random-agent -filter-regex "The plain HTTP request was sent to" -disable-update-check -silent -no-color | tee "$GITHUB_WORKSPACE/main/Data/np_ccTLDs/certstream_domains_np_all_24h_httpx.txt"
#Git Pull
 cd "$GITHUB_WORKSPACE/main" && git pull origin main  
#---------------------# 
#GoWitness
cat "$GITHUB_WORKSPACE/main/Data/np_ccTLDs/certstream_domains_np_all_24h_httpx.txt" | awk '{print $1}' | grep -i 'http' | sort -u -o "/tmp/subs_live.txt"
#Random
#cat "$GITHUB_WORKSPACE/main/Data/np_ccTLDs/certstream_domains_np_all_24h_httpx.txt" | awk '{print $1}' | grep -i 'http' | sort -u | shuf > "/tmp/subs_live.txt"
#output dir is autocreated
#Run gowitness
# 1000 Hosts Screenshot ~ 30-45 mins
 echo -e "\n[+] Total Hosts --> 📷 : $(wc -l < /tmp/subs_live.txt)\n"
 gowitness file -f "/tmp/subs_live.txt" --fullpage --disable-db --debug --screenshot-path "/tmp/goshots"
#Remove Dupes (Prefer Https)
 fdupes "/tmp/goshots" --order=name | grep -v '/https-' | xargs -I {} find {} -type f -delete
#Stats 
 TOTAL_SHOTS="$(find /tmp/goshots -type f | wc -l)" ; echo "Total Shots: $TOTAL_SHOTS"
 TOTAL_SIZE="$(du -h /tmp/goshots | awk '{print $1}')" ; echo "Total Size: $TOTAL_SIZE"
#Git Pull
 cd "$GITHUB_WORKSPACE/main" && git pull origin main
#Copy & Move
 mkdir -p "$GITHUB_WORKSPACE/main/Data/np_ccTLDs/Screenshots"
 #Move to Oblivion
 find "$GITHUB_WORKSPACE/main/Data/np_ccTLDs/Screenshots" -type f -name '*.png' -exec rm {} \; 2>/dev/null
 #Copy
 find "/tmp/goshots" -type f -name '*.png' -exec cp {} $GITHUB_WORKSPACE/main/Data/np_ccTLDs/Screenshots \; 2>/dev/null
#Git Pull
 cd "$GITHUB_WORKSPACE/main" && git pull origin main 
#----------------------------------------------------------------------------#  
