- [**Automated** | ***UpToDate***] Daily (@6 Hrs) Dumps of [CertStream](https://certstream.calidog.io/) [Certificate Logs](https://certificate.transparency.dev/) **Data**
---
- #### **Data**
> > - **Info**: [Certificate Transparency Logs](https://certificate.transparency.dev/) only list **issuance** of website certificates. This data ***may not necessarily indicate newly registered domains***, as Certificates **expire** and are **renewed frequently**.
> > - Instead, use [cemulus/crt](https://github.com/cemulus/crt) to check their history:
> > > ```bash
> > > !# Install:
> > > sudo curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/crt" --to "/usr/local/bin/crt" && sudo chmod +xwr "/usr/local/bin/crt"
> > >
> > > !# Check:
> > > crt "$domain_name"
> > > 
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
