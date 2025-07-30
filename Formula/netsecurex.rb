class Netsecurex < Formula
  desc "Unified Cybersecurity Toolkit for Network Security Assessment"
  homepage "https://github.com/avis-enna/NetSecureX"
  url "https://github.com/avis-enna/NetSecureX/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "8fca3c4ec4c4c10aca306bfe6f6ac2429e93ea2a0a72a48423974082d3886087"
  license "MIT"
  head "https://github.com/avis-enna/NetSecureX.git", branch: "main"

  depends_on "python@3.11"
  depends_on "openssl@3"

  def install
    # Copy source files to libexec
    libexec.install Dir["*"]

    # Install dependencies
    system Formula["python@3.11"].opt_bin/"python3.11", "-m", "pip", "install",
           "--target", libexec/"lib", "-r", libexec/"requirements.txt"

    # Create wrapper script
    (bin/"netsecx").write <<~EOS
      #!/bin/bash
      export PYTHONPATH="#{libexec}/lib:$PYTHONPATH"
      cd "#{libexec}"
      exec "#{Formula["python@3.11"].opt_bin}/python3.11" "#{libexec}/main.py" "$@"
    EOS

    chmod 0755, bin/"netsecx"

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
