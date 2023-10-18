- [**Automated** | ***UpToDate***] Daily (@24 Hrs) Dumps of [CertStream](https://certstream.calidog.io/) [Certificate Logs](https://certificate.transparency.dev/) **Data**
> 1. All the [Scripts](https://github.com/Azathothas/CertStream-Domains/tree/main/.github/scripts) & [Tools](https://github.com/Azathothas/Arsenal/tree/main/certstream) used are OpenSource & Public, as such all this ***comes with no Guarantees | Liabilities.***
> 2. Due to [Github's File Size Limit](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github#file-size-limits), all data is Compressed using [7z](https://www.7-zip.org/faq.html).
> 3. View ***Latest*** Data from the **last 24 Hr** at: [Raw/Latest](https://github.com/Azathothas/CertStream-Domains/tree/main/Raw/Latest)
> > - Download
> > ```bash
> > !# Create a Directory
> > mkdir "./certstream-latest" && cd "./certstream-latest"
> > 
> > !# Download all .7z file
> > for url in $(curl -qfsSL "https://api.github.com/repos/Azathothas/CertStream-Domains/contents/Raw/Latest" -H "Accept: application/vnd.github.v3+json" | jq -r '.[].download_url'); do curl -LO $url; done
> >
> > !# Extract all .7z files
> > !# Install 7z: sudo curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/7z" --to "/usr/local/bin/7z" && sudo chmod +xwr "/usr/local/bin/7z"
> >  find . -iname "*.7z" -exec sh -c '7z x "{}" -o"$(dirname "{}")/$(basename "{}" .7z)"' \;
> > !# Cat all to a single text file
> > find . -maxdepth 1 -type f -iname "certstream_domains.txt" -exec cat {} \; 2>/dev/null | sort -u -o "./certstream_domains_latest.txt" ; wc -l < "./certstream_domains_latest.txt"
> > !# Del .7z files
> > 
> > ```
> 4. View ***Archival*** Data upto **7 Days** at: [Raw/Archive](https://github.com/Azathothas/CertStream-Domains/tree/main/Raw/Archive)
> > - Download
> > ```bash
> > 
> > ```
---
- #### **Data**
> > - **Info**: [Certificate Transparency Logs](https://certificate.transparency.dev/) only list **issuance** of website certificates. This data ***may not necessarily indicate newly registered domains***, as Certificates **expire** and are **renewed frequently**.
> > - Instead, use [cemulus/crt](https://github.com/cemulus/crt) to check their history:
> > > ```bash
> > > !# Install:
> > > sudo curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/crt" --to "/usr/local/bin/crt" && sudo chmod +xwr "/usr/local/bin/crt"
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
> - [**np-ccTLDs**](https://register.com.np/np-ccTLDs)
> > ```mathematica
> > !# Ref: https://register.com.np/np-ccTLDs
> > com.np | coop.np | edu.np | gov.np | info.np | mil.np | name.np | net.np | org.np
> >
> > !# Parsed:
> >  grep -Ei 'com\.np|coop\.np|edu\.np|gov\.np|info\.np|mil\.np|name\.np|net\.np|org\.np' "certstream_domains_np_24h.txt" | sort -u
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
> > ```
