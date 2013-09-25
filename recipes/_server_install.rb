
 case node['platform_family']
 when 'debian'

  case node['platform']
  when 'debian'

    # We need the backports repository for up-to-date Icinga version
    apt_repository 'backports' do
      uri 'http://backports.debian.org/debian-backports'
      distribution node['lsb']['codename'] + '-backports'
      components ['main', 'non-free']
      action :add
    end

  when 'ubuntu'

    apt_repository "formorer-icinga" do
      uri 'http://ppa.launchpad.net/formerer/icinga/ubuntu'
      distribution node['lsb']['codename']
      components ['main']
      keyserver "keyserver.ubuntu.com"
      key "4A132479423673E80ACCA85420EEDAFD36862847"
      action :add
    end

  else
    raise "Unsupported Debian-style platform family: #{node['platform_family']}"
  end

  # TODO: The install process is a bit messy (hard-coded versions)since debian-backports is not used when finding installation candidates
  # Standard packages required by server
  %w(xinetd python php5-curl).each do |pkg|
    package pkg do
      action :install
    end
  end

  %w(icinga icinga-cgi icinga-core).each do |pkg|
    package pkg do
      version node['icinga']['version']
      action :install
      options '-t ' + node['lsb']['codename'] + '-backports'
    end
  end

  include_recipe 'rrdcached'
  include_recipe 'pnp4nagios'

  # Define all services
  %w(icinga xinetd).each do |svc|
    service svc do
      supports :status => true, :restart => true, :reload => true
      action [:enable, :start]
    end
  end

  # Install Icinga Check_mk extension
  include_recipe 'icinga::_server_install_check_mk_source'

  # Configure our server
  include_recipe 'icinga::_server_config'
end
