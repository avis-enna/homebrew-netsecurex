# NetSecureX Homebrew Tap

This is the official Homebrew tap for NetSecureX, a unified cybersecurity toolkit for network security assessment and vulnerability analysis.

## Installation

```bash
# Add the tap
brew tap avis-enna/netsecurex

# Install NetSecureX
brew install netsecurex

# Run the setup wizard
netsecx setup --wizard
```

## What is NetSecureX?

NetSecureX is a comprehensive cybersecurity toolkit that provides:

- **Network Scanning**: Advanced port scanning with service detection
- **SSL/TLS Analysis**: Certificate validation and security assessment
- **Vulnerability Research**: CVE lookup with real-time threat intelligence
- **IP Reputation**: Multi-source threat intelligence checking
- **Security Testing**: Firewall testing, banner grabbing, and more

## Quick Start

After installation, configure your API keys for enhanced functionality:

```bash
# Interactive setup wizard
netsecx setup --wizard

# Check configuration status
netsecx setup --status

# Test basic functionality
netsecx scan 8.8.8.8 --ports "53,80"
netsecx sslcheck google.com
netsecx cve --query "nginx"
```

## API Keys (All Free Tiers Available)

NetSecureX integrates with multiple threat intelligence providers:

- **AbuseIPDB**: 1,000 requests/day - [Get API Key](https://www.abuseipdb.com/api)
- **Vulners**: 100 requests/day - [Get API Key](https://vulners.com/api)
- **VirusTotal**: 500 requests/day - [Get API Key](https://www.virustotal.com/gui/join-us)
- **IPQualityScore**: 5,000 requests/month - [Get API Key](https://www.ipqualityscore.com/create-account)
- **GreyNoise**: 10,000 requests/month - [Get API Key](https://www.greynoise.io/)

## Documentation

- **Main Repository**: [NetSecureX on GitHub](https://github.com/avis-enna/NetSecureX)
- **Full Documentation**: [README.md](https://github.com/avis-enna/NetSecureX/blob/main/README.md)
- **Security Policy**: [SECURITY.md](https://github.com/avis-enna/NetSecureX/blob/main/SECURITY.md)
- **Contributing**: [CONTRIBUTING.md](https://github.com/avis-enna/NetSecureX/blob/main/CONTRIBUTING.md)

## Support

- **Issues**: [GitHub Issues](https://github.com/avis-enna/NetSecureX/issues)
- **Discussions**: [GitHub Discussions](https://github.com/avis-enna/NetSecureX/discussions)

## License

NetSecureX is released under the [MIT License](https://github.com/avis-enna/NetSecureX/blob/main/LICENSE).
