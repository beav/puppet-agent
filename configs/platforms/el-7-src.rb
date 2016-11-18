platform "el-7-src" do |plat|
  plat.servicedir "/var/tmp/PUPPETBUILDROOT/usr/lib/systemd/system"
  plat.defaultdir "/var/tmp/PUPPETBUILDROOT/etc/sysconfig"
  plat.servicetype "systemd"

  plat.make "/usr/bin/make"
  plat.srpm_only true

  plat.provision_with "/bin/true"
  plat.install_build_dependencies_with "/bin/true"
end
