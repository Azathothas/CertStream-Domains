
#### Contents
> - [**Info**](https://github.com/Azathothas/CertStream-Domains/tree/main#info)
> - [**What? | Why?**](https://github.com/Azathothas/CertStream-Domains/tree/main#rationale)
> - [**Enriching/Investigating the Data**](https://github.com/Azathothas/CertStream-Domains/tree/main#data)
> - [**Sources**](https://github.com/Azathothas/CertStream-Domains/tree/main#sources)
> - [**In The Wild**](https://github.com/Azathothas/CertStream-Domains/tree/main#elsewhere)
> - [**Future Ideas**](https://github.com/Azathothas/CertStream-Domains/tree/main#ideas)
> - [**Thanks & Appreciation**](https://github.com/Azathothas/CertStream-Domains/tree/main#thanks)
---
- #### Info
> - [**Automated** | ***UpToDate***] Daily (@24 Hrs) Dumps of [CertStream Certificate Logs](https://certificate.transparency.dev/howctworks/) **Data**
> 1. All the [Scripts](https://github.com/Azathothas/CertStream-Domains/tree/main/.github/scripts) & [Tools](https://github.com/Azathothas/Arsenal/tree/main/certstream) used are OpenSource & Public, as such all this ***comes with no Guarantees | Liabilities.***
> 2. Due to [Github's File Size Limit](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github#file-size-limits), all data is Compressed using [7z](https://www.7-zip.org/faq.html).
> 3. View ***Latest*** Data from the **last 24 Hr** at: [Raw/Latest](https://github.com/Azathothas/CertStream-Domains/tree/main/Raw/Latest)
> > - **`Download`** : [certstream_domains_latest.txt](https://pub.ajam.dev/datasets/certstream/all_latest.txt) (Warning: May Crash Browser)
> > > ```bash
> > > !# Download with wget
> > >  wget "https://pub.ajam.dev/datasets/certstream/all_latest.txt"
> > > !# View without Downloading (Spikes Memory Usage)
> > >  curl -qfsSL "https://pub.ajam.dev/datasets/certstream/all_latest.txt" | less
> > > ```
> > - **`Parse`** (If for some reason, you want to do it manually)
> > ```bash
> > !# Create a Directory
> > mkdir "./certstream-latest" && cd "./certstream-latest"
> > 
> > !# Download all .7z file
> > for url in $(curl -qfsSL "https://api.github.com/repos/Azathothas/CertStream-Domains/contents/Raw/Latest" -H "Accept: application/vnd.github.v3+json" | jq -r '.[].download_url'); do echo -e "\n[+] $url\n" && curl -qfLJO "$url"; done
> >
> > !# Extract all .7z files
> > !# Install 7z: sudo curl -qfsSL "https://bin.ajam.dev/x86_64_Linux/7z" -o "/usr/local/bin/7z" && sudo chmod +xwr "/usr/local/bin/7z"
> > find . -iname "*.7z" -exec sh -c '7z x "{}" -o"$(dirname "{}")/$(basename "{}" .7z)"' \;
> > 
> > !# Cat all to a single text file
> > find . -type f -iname "certstream_domains.txt" -exec cat {} \; 2>/dev/null | sort -u -o "./certstream_domains_latest.txt" ; wc -l < "./certstream_domains_latest.txt"
> > 
> > !# Del .7z files
> > find . -maxdepth 1 -type f -iname "certstream*.7z" -exec rm {} \; 2>/dev/null
> > ```
> 4. View ***Archival*** Data upto **7 Days** at: [Raw/Archive](https://github.com/Azathothas/CertStream-Domains/tree/main/Raw/Archive)
> > - **`Download`** : [certstream_domains_weekly.txt](https://pub.ajam.dev/datasets/certstream/all_weekly.txt) (Warning: May Crash Browser)
> > > ```bash
> > > !# Download with wget
> > >  wget "https://pub.ajam.dev/datasets/certstream/all_weekly.txt"
> > > !# View without Downloading (DANGEROUS for your CPU/RAM)
> > >  curl -qfsSL "https://pub.ajam.dev/datasets/certstream/all_weekly.txt" | less
> > > ``` 
> > - **`Parse`** (If for some reason, you want to do it manually)
> > ```bash
> > !# Create a Directory
> > mkdir "./certstream-7days" && cd "./certstream-7days"
> > 
> > !# Download all .7z file
> > for url in $(curl -qfsSL "https://api.github.com/repos/Azathothas/CertStream-Domains/contents/Raw/Archive" -H "Accept: application/vnd.github.v3+json" | jq -r '.[].download_url'); do echo -e "\n[+] $url\n" && curl -qfLJO "$url"; done
> >
> > !# Extract all .7z files
> > !# Install 7z: sudo curl -qfsSL "https://bin.ajam.dev/x86_64_Linux/7z" -o "/usr/local/bin/7z" && sudo chmod +xwr "/usr/local/bin/7z"
> > find . -iname "*.7z" -exec sh -c '7z x "{}" -o"$(dirname "{}")/$(basename "{}" .7z)"' \;
> > 
> > !# Cat all to a single text file
> > find . -type f -iname "certstream_domains.txt" -exec cat {} \; 2>/dev/null | sort -u -o "./certstream_domains_7days.txt" ; wc -l < "./certstream_domains_7days.txt"
> > 
> > !# Del .7z files
> > find . -maxdepth 1 -type f -iname "certstream*.7z" -exec rm {} \; 2>/dev/null
> > ```
> 5. Do Whatever/However you want !
> > - **`Blue Teamers`**: *Monitor* for `Phising Domains`
> > - **`Red Teamers`** || **`Bug Bounty Hunters`** : *Monitor* for **`new assets`** for your target
> > - **`Statisticians`** || **`Chad Data Analysts`** : *`Have Fun`*
---
- #### **Data**
> > - **Info**: [Certificate Transparency Logs](https://certificate.transparency.dev/) only list **issuance** of website certificates. This data ***may not necessarily indicate newly registered domains***, as Certificates **expire** and are **renewed frequently**.
> > - Instead, use [cemulus/crt](https://github.com/cemulus/crt) to check their history:
> > > ```bash
> > > !# Install:
> > > sudo curl -qfsSL "https://bin.ajam.dev/x86_64_Linux/crt" -o "/usr/local/bin/crt" && sudo chmod +xwr "/usr/local/bin/crt"
> > > ```
> > > > - **Check**
> > > ```bash
> > > crt "$domain_name"
> > > !# Example:
> > > crt "rmb.info.np"
> > > ```
> > > ![image](https://github.com/Azathothas/CertStream-Domains/assets/58171889/25593891-f847-40c0-8ceb-738e46fb8700)
> > > - **Details**
> > > ```bash
> > > crt -json "$domain_name"
> > >
> > > !# Example:
> > > crt -json "rmb.info.np"
> > >  ```
> ---
---
- #### **Rationale**
> ##### **What?**
> - [Azathothas/CertStream-Domains](https://github.com/Azathothas/CertStream-Domains) is an **Append Only (`RFC 6962`)**[https://datatracker.ietf.org/doc/html/rfc6962] dumps of logs.
> - [Azathothas/CertStream-Domains](https://github.com/Azathothas/CertStream-Domains) **only extracts [SAN](https://www.ssl.com/article/the-essential-guide-to-san-certificates/) & [CN](https://www.ssl.com/faqs/common-name/)** from ct-logs.
> ##### **What not?**
> - It is **not a database for pre-existing ones**.
> - There exist a million projects that do the Collection/Database thing a million times better than this repo could ever do. So look elsewhere if you want a DB of certificates & all the data.
> 
> ##### **Why?**
> 1. There used to be [internetwache/CT_subdomains](https://github.com/internetwache/CT_subdomains) which was very similar to this repo. But it **didn't list everything**, and also **hasn't been updated since [`Oct 13, 2021`](https://github.com/internetwache/CT_subdomains/commits/master)**. Read their [Blog](https://en.internetwache.org/certificate-transparency-as-a-source-for-subdomains-14-12-2017/)
> 2. [crt.sh](https://crt.sh/monitored-logs) also monitors the same logs, but there's a *delay (usually 24 Hrs) until it shows up on results*. Furthermore, you will have to *use additional filters to only list newly issued/renewed certs*.
> 3. Services like [SSLMate](https://sslmate.com/certspotter/), [Report-Uri](https://report-uri.com/#prices) & [SecurityTrails](https://securitytrails.com/corp/pricing) either **`monitor only your domains`** || **`do not provide all the data`** || **`Put it behind Paywalls`**.
> > - SSLMate has opensourced their own monitor: [SSLMate/certspotter](https://github.com/SSLMate/certspotter) but the data is [**behind a paywall**](https://sslmate.com/pricing/certspotter).
--- 
- #### **Sources** 
> ~1. [certstream.calidog.io](https://certstream.calidog.io) uses it's own [Server](https://github.com/CaliDog/certstream-server) to fetch [all logs](https://www.gstatic.com/ct/log_list/v3/all_logs_list.json) exposing **`wss://certstream.calidog.io`** for [libraries](https://github.com/search?q=org%3ACaliDog+certstream&type=repositories). [Azathothas/certstream](https://github.com/Azathothas/Arsenal/tree/main/certstream) is a simple cli that uses the [go library](https://github.com/CaliDog/certstream-go).~
> > [certstream.calidog.io](https://certstream.calidog.io) has been dropped in favour of a [completely self-hosted solution](https://github.com/Azathothas/Arsenal/tree/main/certstream). See: https://github.com/Azathothas/CertStream-Domains/issues/6
> 2. List of logs monitored: **https://www.gstatic.com/ct/log_list/v3/all_logs_list.json**
---
- #### **Elsewhere**
> - [Seeing how fast people will probe you after you get a new TLS certificate](https://utcc.utoronto.ca/~cks/space/blog/web/WebProbeSpeedNewTLSCertificate)
> - [Azathothas/CertStream-Nepal](https://github.com/Azathothas/CertStream-Nepal) : [Automated | UpToDate] Daily Dumps of CertStream Subdomains Data For Nepal 🇳🇵
> - [RebootEx/CertStream-Bangladesh](https://github.com/RebootEx/CertStream-Bangladesh) : [Automated | UpToDate] Daily Dumps of CertStream Subdomains Data For Bangladesh 🇧🇩
> - [Azathothas/CertStream-World](https://github.com/Azathothas/CertStream-World) : [Automated | UpToDate] Daily Dumps of CertStream Subdomains Data For the World 🌐 
---
- #### **Ideas**
> 1. Use something like [mouday/domain-admin](https://github.com/mouday/domain-admin) if looking to monitor only specific domains.
> 2. Use something like [letsencrypt/ct-woodpecker/ct-woodpecker](https://github.com/letsencrypt/ct-woodpecker) if looking for detailed output with stats & monitors ([Prometheus](https://prometheus.io/)) for Production.
> 3. Use something like [drfabiocastro/certwatcher](https://github.com/drfabiocastro/certwatcher) if looking for Automation. This is essentially *nuclei for cert-logs.*
---
- #### **Thanks**
> 1. [The Hacker's Choice](https://www.thc.org/) for proividing [servers](https://github.com/Azathothas/CertStream-Domains/blob/main/SERVERS.md) on [segfault](https://github.com/hackerschoice/segfault) & being so generous.
> > - [Telegram](https://t.me/thcorg) : `@thcorg` | [Github](https://github.com/hackerschoice) : https://github.com/hackerschoice
