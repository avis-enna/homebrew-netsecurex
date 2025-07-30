class Netsecurex < Formula
  desc "Unified Cybersecurity Toolkit for Network Security Assessment"
  homepage "https://github.com/avis-enna/NetSecureX"
  url "https://github.com/avis-enna/NetSecureX/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "YOUR_SHA256_HASH_HERE"  # Will be calculated when you create the release
  license "MIT"
  head "https://github.com/avis-enna/NetSecureX.git", branch: "main"

  depends_on "python@3.11"
  depends_on "openssl@3"

  # Python dependencies
  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.2.1.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/87/67/a37f6214d0e9fe57f6c54024d76ef72ca080bf8e54b2e41ab7dfb595bb929/rich-14.1.0.tar.gz"
    sha256 "8260cda28e3db6bf04d2d1ef4dbc03ba80a824c88b0e7668a0f23126a424844a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.4.tar.gz"
    sha256 "55365417734eb18255590a9c9e97d9d1d5d5e4f0f7c8b5c0f4c0b8b8b8b8b8b8"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/de/ba/0664727028b37e249e73879348cc46d45c5c1a2a2e81e8166462953c5755/cryptography-45.0.5.tar.gz"
    sha256 "8780356d5b4909907c6ac24b2e1b5b2d1c9c8496a9c5c9c8c8c8c8c8c8c8c8c8"
  end

  def install
    # Create virtualenv
    venv = virtualenv_create(libexec, "python3.11")
    
    # Install Python dependencies
    venv.pip_install resources
    venv.pip_install buildpath

    # Create the main executable
    (bin/"netsecx").write_env_script libexec/"bin/python", libexec/"bin/netsecurex",
      PATH: "#{libexec}/bin:$PATH"

    # Install configuration directory
    (etc/"netsecurex").mkpath
    
    # Install example configuration
    (etc/"netsecurex/config.example.yaml").write <<~EOS
      # NetSecureX Configuration
      # Copy this file to ~/.netsecurex/config.yaml and add your API keys
      
      api_keys:
        # AbuseIPDB API Key (free tier available)
        # Get from: https://www.abuseipdb.com/api
        abuseipdb: "your_abuseipdb_api_key_here"
        
        # IPQualityScore API Key (free tier available)
        # Get from: https://www.ipqualityscore.com/create-account
        ipqualityscore: "your_ipqualityscore_api_key_here"
        
        # VirusTotal API Key (free tier available)
        # Get from: https://www.virustotal.com/gui/join-us
        virustotal: "your_virustotal_api_key_here"
        
        # Vulners API Key (free tier available)
        # Get from: https://vulners.com/api
        vulners: "your_vulners_api_key_here"
        
        # Shodan API Key (paid service)
        # Get from: https://www.shodan.io/
        shodan: "your_shodan_api_key_here"
        
        # GreyNoise API Key (free tier available)
        # Get from: https://www.greynoise.io/
        greynoise: "your_greynoise_api_key_here"

      # Default settings
      settings:
        timeout: 10
        max_concurrent: 100
        log_level: "INFO"
        output_format: "table"
    EOS

    # Install documentation
    doc.install "README.md"
    doc.install "examples"
  end

  def post_install
    # Create user config directory
    config_dir = "#{Dir.home}/.netsecurex"
    system "mkdir", "-p", config_dir unless Dir.exist?(config_dir)
    
    # Copy example config if user config doesn't exist
    user_config = "#{config_dir}/config.yaml"
    unless File.exist?(user_config)
      system "cp", "#{etc}/netsecurex/config.example.yaml", user_config
    end
  end

  def caveats
    <<~EOS
      NetSecureX has been installed successfully!

      Configuration:
        Edit ~/.netsecurex/config.yaml to add your API keys.
        
      API Keys (all have free tiers):
        • AbuseIPDB: https://www.abuseipdb.com/api
        • IPQualityScore: https://www.ipqualityscore.com/create-account
        • VirusTotal: https://www.virustotal.com/gui/join-us
        • Vulners: https://vulners.com/api
        • GreyNoise: https://www.greynoise.io/
        • Shodan: https://www.shodan.io/ (paid)

      Usage:
        netsecx --help
        netsecx cve --query "nginx"
        netsecx scan 192.168.1.1
        netsecx sslcheck google.com

      Documentation:
        #{doc}/README.md
        #{doc}/examples/
    EOS
  end

  test do
    assert_match "NetSecureX", shell_output("#{bin}/netsecx version")
    assert_match "Usage:", shell_output("#{bin}/netsecx --help")
  end
end
