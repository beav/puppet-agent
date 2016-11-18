component "puppet-ca-bundle" do |pkg, settings, platform|
  pkg.load_from_json("configs/components/puppet-ca-bundle.json")

  pkg.build_requires "openssl"

  java_available = true
  case platform.name
  when /fedora-f20/
    pkg.build_requires 'java-1.7.0-openjdk-devel'
  when /(el-(6|7)|fedora-(f21|f22|f23|f24))/
    pkg.build_requires 'java-1.8.0-openjdk-devel'
  when /(debian-(7|8)|ubuntu-(12|14))/
    pkg.build_requires 'openjdk-7-jdk'
  when /(debian-9|ubuntu-(15|16))/
    pkg.build_requires 'openjdk-8-jdk'
  when /sles-12/
    pkg.build_requires 'java-1_7_0-openjdk-devel'
  when /sles-11/
    pkg.build_requires 'java-1_7_0-ibm-devel'
  else
    java_available = false
  end

  openssl_cmd = "#{settings[:bindir]}/openssl"
  if platform.is_cross_compiled_linux?
    # Use the build host's openssl command, not our cross-compiled one
    openssl_cmd = "/usr/bin/openssl"
  end

  if platform.srpm_only
    install_commands = [
      "#{platform[:make]} install OPENSSL=#{openssl_cmd} DESTDIR=#{File.join(settings[:prefix], 'ssl')}"
    ]
  else
    install_commands = [
      "#{platform[:make]} install OPENSSL=#{openssl_cmd} USER=0 GROUP=0 DESTDIR=#{File.join(settings[:prefix], 'ssl')}"
    ]
  end

  # We need to ensure we install the keystore on platforms which have java available
  if java_available
    install_commands << "#{platform[:make]} keystore OPENSSL=#{openssl_cmd} DESTDIR=#{File.join(settings[:prefix], 'ssl')}"
  end

  pkg.install do
    install_commands
  end
end
