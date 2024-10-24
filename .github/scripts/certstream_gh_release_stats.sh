#!/usr/bin/env bash

#-------------------------------------------------------#
# Download the Archive TAR into a new folder, chdir to that folder and run
# bash <(curl -qfsSL "https://@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/certstream_gh_release_stats.sh")
# Requires: coreutils + 7z (+tar)
# Specs: [RAM: 32 GB || vCPU: 2 (70%) || Disk: ~ 50 GB]
#-------------------------------------------------------#

#-------------------------------------------------------#
#ENV
CT_MONTH="$(date -d '-1 month' +'%Y_%m')" && export CT_MONTH="${CT_MONTH}"
echo -e "\n[+] Month: ${CT_MONTH}"
CT_TXT="certstream_${CT_MONTH}.txt" && export CT_TXT="${CT_TXT}" ; rm -rf "${CT_TXT}" 2>/dev/null
#tar to 7z
find "$(realpath .)" -maxdepth 1 -type f -iname "*certstream*.tar" -exec 7z x -mmt="$(($(nproc)+1))" -bt -y {} \;
#7z to .txt
find "$(realpath .)" -maxdepth 1 -type f -iname "*.7z" -exec 7z x -mmt="$(($(nproc)+1))" -bt -y {} \;
#.txt to Single TXT
echo -e "\n[+] Writing to ${CT_TXT}\n"
#Consumes: RAM (High ~ 30-50 GB) + CPU (Mid) + Time (~1-2 HR)
find "$(realpath .)" -type f -name "*.txt" -exec cat {} + | sort -u -o "${CT_TXT}"
find "$(realpath .)" -type f -name "*.txt" ! -name "*certstream*" -exec cat {} + > "${CT_TXT}.bak"
#Archive
7z a -r -t7z -mx="9" -mmt="$(($(nproc)+1))" "certstream_${CT_MONTH}_sorted.7z" "${CT_TXT}" 2>/dev/null
#7z a -r -t7z -mx="9" -mmt="$(($(nproc)+1))" "${CT_TXT}.bak.7z" "${CT_TXT}.bak" 2>/dev/null
#Stats
CT_LINES_U="$(wc -l < "${CT_TXT}")" && export CT_LINES_U="${CT_LINES_U}"
CT_SIZE_U="$(du -sh "${CT_TXT}" | cut -f1)" && export CT_SIZE_U="${CT_SIZE_U}"
CT_LINES_T="$(wc -l < "${CT_TXT}.bak")" && export CT_LINES_T="${CT_LINES_T}"
CT_SIZE_T="$(du -sh "${CT_TXT}.bak" | cut -f1)" && export CT_SIZE_T="${CT_SIZE_T}"
echo -e "\n[+] Total Domains (Raw): ${CT_LINES_T} [${CT_SIZE_T}]"
echo -e "[+] Unique Domains (Sorted): ${CT_LINES_U} [${CT_SIZE_U}]"
echo -e "[+] 7z Archive (Unique Domains): $(du -sh "certstream_${CT_MONTH}_sorted.7z")]\n"
#END
#-------------------------------------------------------#

#-------------------------------------------------------#
##Release
#Tag: YYYY.MM
#Title: CertStream Monthly Dump (YYYY-MM)
#Body:
# Archive of [`CertStream Daily Dumps`](https://github.com/Azathothas/CertStream-Domains/tree/main/Raw/Latest) (`YYYY-MM-DD-YYYY-MM-DD`)
# Helper Script: https://github.com/Azathothas/CertStream-Domains/blob/main/.github/scripts/certstream_gh_release_stats.sh
# ```bash
# !#STATS
# {STATS}
# !#BANDWIDTH (Avg./Server) eth0/monthly: vnstat -m  
# month        rx       |     tx      |    total    |   avg. rate
# ------------------------+-------------+-------------+---------------
# 2024-08      4.42 TiB |   94.32 GiB |    4.51 TiB |   14.81 Mbit/s
# ------------------------+-------------+-------------+---------------
# ```
#-------------------------------------------------------#
