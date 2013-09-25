
# Install and configure the dependencies
include_recipe 'icinga::_server_depends'

# Install Icinga and Check_mk
include_recipe 'et_icinga::_server_install'

# Install the Icinga client recipe
include_recipe 'icinga::client'
