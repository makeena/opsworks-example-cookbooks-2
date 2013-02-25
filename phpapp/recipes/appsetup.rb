node[:deploy].each do |app_name, deploy|

  script "setup_symfony1" do
    interpreter "bash"
    user "root"
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
    sudo chown -R www-data cache
    sudo chown -R www-data web/uploads
    EOH
    only_if "test -d #{cwd}/cache"
  end

  script "install_composer" do
    interpreter "bash"
    user "root"
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
    curl -s https://getcomposer.org/installer | php
    php composer.phar install
    mkdir app/logs app/cache
    sudo chown -R www-data app/logs app/cache/
    EOH
    only_if "test -f #{cwd}/composer.json"
  end
end
