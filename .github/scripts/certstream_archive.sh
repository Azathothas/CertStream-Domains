#!/usr/bin/env bash

#Continuous Archives from https://pub.ajam.dev/datasets/certstream/Temp/ to "$HOME/certstream_data"
##Requires: coreutils + curl + dateutils + wget

##ENV
 USER="$(whoami)" && export USER="$USER"
 HOME="$(getent passwd $USER | cut -d: -f6)" && export HOME="${HOME}"
 mkdir -p "${HOME}/bin" "${HOME}/.local/bin"
 export PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"
 SYSTMP="$(dirname $(mktemp -u))" && export SYSTMP="${SYSTMP}"
 USER_AGENT="$(curl -qfsSL 'https://pub.ajam.dev/repos/Azathothas/Wordlists/Misc/User-Agents/ua_chrome_macos_latest.txt')" && export USER_AGENT="${USER_AGENT}"
 #Archive
 if [[ -z "${CT_ARCHIVE}" ]]; then
     CT_ARCHIVE="${HOME}/certstream_data" && export CT_ARCHIVE="${CT_ARCHIVE}"
 fi
 #Echo
 echo -e "\n[+] User :: ${USER}"
 echo -e "[+] Home :: ${HOME}"
 echo -e "[+] Archive :: ${CT_ARCHIVE}\n"
 
##Archive
while true
   do
     TODAY="$(date --utc +'%Y_%m_%d')"
     YDAY="$(date --utc -d "$(date --utc +'%Y-%m-%d') - 1 day" +'%Y_%m_%d')"
     mkdir -p "${CT_ARCHIVE}"
     wget --quiet --show-progress "https://pub.ajam.dev/datasets/certstream/Temp/${TODAY}.7z" -O "${CT_ARCHIVE}/${TODAY}.7z"     
     wget --quiet --show-progress "https://pub.ajam.dev/datasets/certstream/Temp/${YDAY}.7z" -O "${CT_ARCHIVE}/${YDAY}.7z"
     sleep 120m
   done
##END
