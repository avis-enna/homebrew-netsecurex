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

    # Install core dependencies manually
    deps = %w[
      click>=8.1.0
      rich>=13.0.0
      requests>=2.31.0
      PyYAML>=6.0.0
      cryptography>=41.0.0
      aiohttp>=3.8.0
      dnspython>=2.4.0
      pydantic>=2.0.0
      python-dateutil>=2.8.0
      structlog>=23.0.0
      tabulate>=0.9.0
      netaddr>=0.8.0
    ]

    system Formula["python@3.11"].opt_bin/"python3.11", "-m", "pip", "install",
           "--target", libexec/"lib", *deps

    # Create wrapper script
    (bin/"netsecx").write <<~EOS
      #!/bin/bash
      export PYTHONPATH="#{libexec}/lib:#{libexec}:$PYTHONPATH"
      cd "#{libexec}"
      exec "#{Formula["python@3.11"].opt_bin}/python3.11" "#{libexec}/main.py" "$@"
    EOS

    chmod 0755, bin/"netsecx"

    # Install documentation if it exists
    doc.install "README.md" if File.exist?("README.md")
    doc.install "examples" if Dir.exist?("examples")
  end



  def caveats
    <<~EOS
      NetSecureX has been installed successfully!

      Setup:
        netsecx setup --wizard

      Usage:
        netsecx --help
        netsecx cve --query "nginx"
        netsecx scan 192.168.1.1
        netsecx sslcheck google.com
    EOS
  end

  test do
    assert_match "NetSecureX", shell_output("#{bin}/netsecx version")
    assert_match "Usage:", shell_output("#{bin}/netsecx --help")
  end
end
