set :user,        "search"
set :deploy_to,   "/home/search/#{application}"
set :domain,      "192.168.100.169"
server domain, :app, :web, :db, :primary => true

before "deploy:cleanup", "restart_resque_workers"
after :deploy, "warmup"

task :restart_resque_workers, :roles => :web do
  run "/home/search/scripts/stop_resque_workers"
  run "/home/search/scripts/start_resque_workers"
end

task :warmup, :roles => :web do
  run "wget --delete-after --user=demo --password=***REMOVED*** http://searchdemo.usa.gov"
end
