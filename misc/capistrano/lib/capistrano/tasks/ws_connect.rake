namespace :deploy do

  desc 'upload database.yml files'
  task :upload do
    on roles(:app) do |host|
      require 'erb'
      html = ERB.new(File.read("templates/database.yml.erb")).result(binding)
      upload!(StringIO.new(html), "#{shared_path}/config/database.yml")
    end
  end

  desc 'add permission'
  task :add_permission do
    on roles(:app) do |host|
      execute "chmod g+w -R #{release_path}"
    end
  end

  before 'deploy:check:linked_files', 'deploy:upload'
  after :finishing, 'deploy:cleanup'
  after 'deploy:cleanup', 'deploy:add_permission'

  desc 'upload monit config files'
  task :upload_monitrc do
    on roles(:app) do |host|
      require 'erb'
      html = ERB.new(File.read("templates/monit.rc.erb")).result(binding)
      upload!(StringIO.new(html), "#{shared_path}/config/#{application}.monit.rc")
    end
  end

  desc 'upload nginx config files'
  task :upload_nginx_config do
    on roles(:app) do |host|
      require 'erb'
      html = ERB.new(File.read("templates/nginx.conf.erb")).result(binding)
      upload!(StringIO.new(html), "#{shared_path}/config/#{application}.nginx.conf")
    end
  end

  desc 'restart puma'
  task :restart_puma do
    on roles(:app) do |host|
      execute "kill -USR2 `cat #{current_path}/tmp/pids/puma.pid`"
    end
  end


  after 'deploy:finishing',           'deploy:upload_monitrc'
  after 'deploy:upload_monitrc',      'deploy:upload_nginx_config'
#  after 'deploy:upload_nginx_config', 'deploy:restart_puma'

end
