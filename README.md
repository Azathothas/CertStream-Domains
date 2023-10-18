- [**Automated** | ***UpToDate***] Daily (@6 Hrs) Dumps of [CertStream](https://certstream.calidog.io/) [Certificate Logs](https://certificate.transparency.dev/) **Data**
---
- #### **Data**
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
> > ```
---
- #### 🖨️ **Stats** ⏲️
```console


--> 🌐 Total
[+] New/ReNewed SSL Certs (ALL): +1140187


--> 🇳🇵 np_ccTLDs
[+] New/ReNewed SSL Certs (ALL): +626

[+] New/ReNewed SSL Certs (Edu): +28

[+] New/ReNewed SSL Certs (Gov|Mil): +2


```

---

