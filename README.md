

---
- #### 🖨️ **Stats** `24Hr`⏲️ ➼ 2023_11_11
```console


--> 🌐 Total
[+] New/ReNewed SSL Certs (ALL): +2140784


--> 🇳🇵 np_ccTLDs
[+] New/ReNewed SSL Certs (ALL): +614
[+] New/ReNewed SSL Certs (Edu): +80
[+] New/ReNewed SSL Certs (Gov|Mil): +44
[+] New/ReNewed SSL Certs (ISPs): +1


```

---
- #### 🖨️ **Stats** `7Days`⏲️ ➼ 2023_11_11 <--> 2023_11_04
```console


--> 🌐 Total
[+] New/ReNewed SSL Certs (ALL): +56265995


--> 🇳🇵 np_ccTLDs
[+] New/ReNewed SSL Certs (ALL): +19406
[+] New/ReNewed SSL Certs (Edu): +2152
[+] New/ReNewed SSL Certs (Gov|Mil): +555
[+] New/ReNewed SSL Certs (ISPs): +14


```

---


#### Contents
> - [**Info**](https://github.com/Azathothas/CertStream-Domains/tree/main#info)
> - [**What? | Why?**](https://github.com/Azathothas/CertStream-Domains/tree/main#rationale)
> - [**Enriching/Investigating the Data**](https://github.com/Azathothas/CertStream-Domains/tree/main#data)
> - [**Sources**](https://github.com/Azathothas/CertStream-Domains/tree/main#sources)
> - [**Future Ideas**](https://github.com/Azathothas/CertStream-Domains/tree/main#ideas)
> - [**Thanks & Appreciation**](https://github.com/Azathothas/CertStream-Domains/tree/main#thanks)
---
- #### Info
> - [**Automated** | ***UpToDate***] Daily (@24 Hrs) Dumps of [CertStream](https://certstream.calidog.io/) [Certificate Logs](https://certificate.transparency.dev/howctworks/) **Data**
> 1. All the [Scripts](https://github.com/Azathothas/CertStream-Domains/tree/main/.github/scripts) & [Tools](https://github.com/Azathothas/Arsenal/tree/main/certstream) used are OpenSource & Public, as such all this ***comes with no Guarantees | Liabilities.***
> 2. Due to [Github's File Size Limit](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github#file-size-limits), all data is Compressed using [7z](https://www.7-zip.org/faq.html).
> 3. View ***Latest*** Data from the **last 24 Hr** at: [Raw/Latest](https://github.com/Azathothas/CertStream-Domains/tree/main/Raw/Latest)
> > - **`Download`** : [certstream_domains_latest.txt](https://r2-pub.prashansa.com.np/certstream_domains_latest.txt) (Warning: May Crash Browser)
> > > ```bash
> > > !# Download with wget
> > >  wget "https://r2-pub.prashansa.com.np/certstream_domains_latest.txt"
> > > !# View without Downloading (Spikes Memory Usage)
> > >  curl -qfsSL "https://r2-pub.prashansa.com.np/certstream_domains_latest.txt" | less
> > > ```
> > - **`Parse`** (If for some reason, you want to do it manually)
> > ```bash
> > !# Create a Directory
> > mkdir "./certstream-latest" && cd "./certstream-latest"
> > 
> > !# Download all .7z file
> > for url in $(curl -qfsSL "https://api.github.com/repos/Azathothas/CertStream-Domains/contents/Raw/Latest" -H "Accept: application/vnd.github.v3+json" | jq -r '.[].download_url'); do curl -LJO $url; done
> >
> > !# Extract all .7z files
> > !# Install 7z: sudo curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/7z" -o "/usr/local/bin/7z" && sudo chmod +xwr "/usr/local/bin/7z"
> > find . -iname "*.7z" -exec sh -c '7z x "{}" -o"$(dirname "{}")/$(basename "{}" .7z)"' \;
> > 
> > !# Cat all to a single text file
> > find . -type f -iname "certstream_domains.txt" -exec cat {} \; 2>/dev/null | sort -u -o "./certstream_domains_latest.txt" ; wc -l < "./certstream_domains_latest.txt"
> > 
> > !# Del .7z files
> > find . -maxdepth 1 -type f -iname "certstream*.7z" -exec rm {} \; 2>/dev/null
> > ```
> 4. View ***Archival*** Data upto **7 Days** at: [Raw/Archive](https://github.com/Azathothas/CertStream-Domains/tree/main/Raw/Archive)
> > - **`Download`** : [certstream_domains_weekly.txt](https://r2-pub.prashansa.com.np/certstream_domains_weekly.txt) (Warning: May Crash Browser)
> > > ```bash
> > > !# Download with wget
> > >  wget "https://r2-pub.prashansa.com.np/certstream_domains_weekly.txt"
> > > !# View without Downloading (DANGEROUS for your CPU/RAM)
> > >  curl -qfsSL "https://r2-pub.prashansa.com.np/certstream_domains_weekly.txt" | less
> > > ``` 
> > - **`Parse`** (If for some reason, you want to do it manually)
> > ```bash
> > !# Create a Directory
> > mkdir "./certstream-7days" && cd "./certstream-7days"
> > 
> > !# Download all .7z file
> > for url in $(curl -qfsSL "https://api.github.com/repos/Azathothas/CertStream-Domains/contents/Raw/Archive" -H "Accept: application/vnd.github.v3+json" | jq -r '.[].download_url'); do curl -LJO $url; done
> >
> > !# Extract all .7z files
> > !# Install 7z: sudo curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/7z" -o "/usr/local/bin/7z" && sudo chmod +xwr "/usr/local/bin/7z"
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
> > > sudo curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/crt" -o "/usr/local/bin/crt" && sudo chmod +xwr "/usr/local/bin/crt"
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
> Note: This is _just an example_, the full data contains logs from **every country** (**`TLD`**), **Worldwide**.
> - [**np-ccTLDs**](https://register.com.np/np-ccTLDs)
> > ```mathematica
> > !# Ref: https://register.com.np/np-ccTLDs
> > com.np | coop.np | edu.np | gov.np | info.np | mil.np | name.np | net.np | org.np
> >
> > !# ISPs
> > CG Net | ClassicTech | Ncell | NTC | Subisu | Vianet | Wordlink
> > 
> > !# Parsed: (Main)
> >  grep -Ei 'com\.np|coop\.np|edu\.np|gov\.np|info\.np|mil\.np|name\.np|net\.np|org\.np' "certstream_domains_latest.txt" | sort -u
> >
> > !# Parsed: (ISPs)
> > grep -i 'cgnet.com.np\|classic.com.np\|ncell.axiata.com\|ncell.com.np\|nettv.com.np\|ntc.net.np\|snpl.net.np\|subisu.net.np\|vianet.com.np\|via.net.np\|viatv.com.np\|wlink.com.np\|wlinktech.com.np\|worldlink.com.np' "certstream_domains_latest.txt" | sort -u
> > 
> > !# Grep for something Particular
> > !# Example: List only .gov
> >  grep -Ei 'gov\.np' "certstream_domains_np_24h.txt" | sort -u
> >
> > !# DL:
> > !# ALL
> > wget "https://raw.githubusercontent.com/Azathothas/CertStream-Domains/main/Data/np_ccTLDs/certstream_domains_np_all_24h.txt"
> > View: curl -qfsSL "https://raw.githubusercontent.com/Azathothas/CertStream-Domains/main/Data/np_ccTLDs/certstream_domains_np_all_24h.txt" | less
> > 
> > !# Only edu.np
> > wget "https://raw.githubusercontent.com/Azathothas/CertStream-Domains/main/Data/np_ccTLDs/certstream_domains_np_edu_24h.txt"
> > View: curl -qfsSL "https://raw.githubusercontent.com/Azathothas/CertStream-Domains/main/Data/np_ccTLDs/certstream_domains_np_edu_24h.txt" | less
> > 
> > !# Only gov.np | mil.np
> > wget "https://raw.githubusercontent.com/Azathothas/CertStream-Domains/main/Data/np_ccTLDs/certstream_domains_np_gov_mil_24h.txt"
> > View: curl -qfsSL "https://raw.githubusercontent.com/Azathothas/CertStream-Domains/main/Data/np_ccTLDs/certstream_domains_np_gov_mil_24h.txt" | less
> >
> > !# Only ISP
> > wget "https://raw.githubusercontent.com/Azathothas/CertStream-Domains/main/Data/np_ccTLDs/certstream_domains_np_isp_24h.txt"
> > View: curl -qfsSL "https://raw.githubusercontent.com/Azathothas/CertStream-Domains/main/Data/np_ccTLDs/certstream_domains_np_isp_24h.txt" | less
> > ```
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
> 1. [certstream.calidog.io](https://certstream.calidog.io) uses it's own [Server](https://github.com/CaliDog/certstream-server) to fetch [all logs](https://www.gstatic.com/ct/log_list/v3/all_logs_list.json) exposing **`wss://certstream.calidog.io`** for [libraries](https://github.com/search?q=org%3ACaliDog+certstream&type=repositories). [Azathothas/certstream](https://github.com/Azathothas/Arsenal/tree/main/certstream) is a simple cli that uses the [go library](https://github.com/CaliDog/certstream-go).
> 2. List of logs monitored: **https://www.gstatic.com/ct/log_list/v3/all_logs_list.json**
---
- #### **Ideas**
> 1. Use something like [mouday/domain-admin](https://github.com/mouday/domain-admin) if looking to monitor only specific domains.
> 2. Use something like [letsencrypt/ct-woodpecker/ct-woodpecker](https://github.com/letsencrypt/ct-woodpecker) if looking for detailed output with stats & monitors ([Prometheus](https://prometheus.io/)) for Production.
> 3. Use something like [drfabiocastro/certwatcher](https://github.com/drfabiocastro/certwatcher) if looking for Automation. This is essentially *nuclei for cert-logs.*
---
- #### **Thanks**
> 1. [The Hacker's Choice](https://www.thc.org/) for proividing [servers](https://github.com/Azathothas/CertStream-Domains/blob/main/SERVERS.md) on [segfault](https://github.com/hackerschoice/segfault) & being so generous.
> > - [Telegram](https://t.me/thcorg) : `@thcorg` | [Github](https://github.com/hackerschoice) : https://github.com/hackerschoice
