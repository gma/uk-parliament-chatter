set :application, "uk-company-chatter"
set :repository, "git://github.com/gma/#{application}.git"
# set :revision, "origin/master"
set :domain, "fig.effectif.com"
set :deploy_to, "/var/apps/#{application}"

require "tempfile"
require "vlad"

namespace :vlad do
  remote_task :config_yml do
    put "#{shared_path}/config.yml", "vlad.config.yml" do
      File.open(File.join(File.dirname(__FILE__), "config.yml")).read
    end
  end
  
  task :setup do
    Rake::Task['vlad:config_yml'].invoke
  end
  
  remote_task :symlink_config_yml do
    run "ln -s #{shared_path}/config.yml #{current_path}/config/config.yml"
  end
  
  remote_task :symlink_attachments do
    run "ln -s #{shared_path}/content/attachments #{current_path}/public/attachments"
  end
  
  task :update do
    Rake::Task['vlad:symlink_config_yml'].invoke
    Rake::Task['vlad:symlink_attachments'].invoke
  end
end
