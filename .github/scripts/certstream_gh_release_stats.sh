#!/usr/bin/env bash

#-------------------------------------------------------#
# This should be run in the same dir as the .tar archives
# bash <(curl -qfsSL "https://@raw.githubusercontent.com/Azathothas/CertStream-Domains/main/.github/scripts/certstream_gh_release_stats.sh")
# Requires: coreutils + 7z (+tar)
# Consumes: RAM (High ~ 15-20 GB) + CPU (Mid)
#-------------------------------------------------------#

#ENV
CT_MONTH="$(date -d '-1 month' +'%Y_%m')" && export CT_MONTH="${CT_MONTH}"
echo -e "\n[+] Month: ${CT_MONTH}"
CT_TXT="certstream_${CT_MONTH}.txt" && export CT_TXT="${CT_TXT}" ; rm -rf "${CT_TXT}" 2>/dev/null
#tar to 7z
find "$(realpath .)" -type f -name "*.tar" -exec 7z x -mmt="$(($(nproc)+1))" -bt -y {} \;
#7z to .txt
find "$(realpath .)" -type f -name "*.7z" -exec 7z x -mmt="$(($(nproc)+1))" -bt -y {} \;
#.txt to Single TXT
echo -e "\n[+] Writing to ${CT_TXT}\n"
find "$(realpath .)" -type f -name "*.txt" -exec cat {} + | sort -u -o "${CT_TXT}"
find "$(realpath .)" -type f -name "*.txt" -exec cat {} + > "${CT_TXT}.bak"
#Archive
7z a -r -t7z -mx="9" -mmt="$(($(nproc)+1))" "${CT_TXT}.7z" "${CT_TXT}" 2>/dev/null
7z a -r -t7z -mx="9" -mmt="$(($(nproc)+1))" "${CT_TXT}.bak.7z" "${CT_TXT}.bak" 2>/dev/null
#Stats
CT_LINES_U="$(wc -l < "${CT_TXT}")" && export CT_LINES_U="${CT_LINES_U}"
CT_LINES_T="$(wc -l < "${CT_TXT.bak}")" && export CT_LINES_T="${CT_LINES_T}"
CT_SIZE_U="$(du -sh "${CT_TXT}")" && export CT_SIZE_U="${CT_SIZE_U}"
CT_SIZE_T="$(du -sh "${CT_TXT.bak}")" && export CT_SIZE_T="${CT_SIZE_T}"
echo -e "\n[+]Total Domains: ${CT_LINES_T} [${CT_SIZE_T}]"
echo -e "[+]Unique Domains: ${CT_LINES_U} [${CT_SIZE_U}]\n"
#END
