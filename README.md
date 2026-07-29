# VulnHunter-AI Community

<p align="center">
<img src="assets/images/banner.png" width="100%">
</p>

Free reconnaissance framework for authorized Bug Bounty and penetration testing.

## Features

- Subdomain Enumeration
- Live Host Discovery
- URL Collection
- JavaScript Endpoint Extraction
- GraphQL Discovery
- HTTP Header Analysis
- API Inventory
- Markdown Reports

---

# Screenshots

## Dashboard

![](assets/images/dashboard.png)

---

## Markdown Report

![](assets/images/markdown-report.jpg)

---

## Output Structure

![](assets/images/output-structure.png)

---

## Available Modules

![](assets/images/module-list.png)

---

## Installation

```bash
git clone https://github.com/yosiismalov/VulnHunter-AI-Community.git
cd VulnHunter-AI-Community

chmod +x vuln_hunter.sh
chmod +x check_install.sh
chmod +x recon/recon.sh
chmod +x analyzers/*.sh
chmod +x reports/report.sh

./check_install.sh
```

## Usage

```bash
./vuln_hunter.sh example.com
```

## Output

Reports:

```text
reports/example.com_report.md
```

Results:

```text
output/example.com/
```

---

# Upgrade to VulnHunter-AI Pro

The Pro edition includes:

- AI Analysis
- HTML Dashboard
- API Ranking
- Bug Likelihood Engine
- Attack Path Generator
- Parameter Intelligence
- Authentication Flow Discovery
- Response Fingerprinting
- Live API Validation

## Demo Video

Download:

**assets/video/demo.mp4**

or watch it directly on GitHub after opening the file.

## Get VulnHunter-AI Pro

https://yosiismalov.gumroad.com/l/vulnhunter-ai-pro

---

## License

MIT
