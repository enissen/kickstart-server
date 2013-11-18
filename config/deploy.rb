default_run_options[:pty] = true  # Must be set for the password prompt from git to work

set :application, 		"kickstart-server"
set :repository,  		"git@github.com:niftysniffer/kickstart-server.git"
set :ip,             	"91.250.87.191"

set :deploy_to,   		"/srv/#{application}"

set :scm, 				"git"
set :user, 				"root" 			#"deploy"
#set :scm_passphrase, 	"Er$Ni.2712"	#"D1ploy!"

set :ssh_options, 		{ :forward_agent => true }
set :branch, 			"master"
set :deploy_via, 		:remote_cache

role :web, 				"#{ip}"     
role :app, 				"#{ip}"   

###########################################################

namespace :symlink do
  desc "symlinks lib directory" 
  task :lib do
    run "ln -fs #{shared_path}/lib #{release_path}/lib" 
  end

  desc "symlinks src directory" 
  task :src do
    run "ln -fs #{shared_path}/src #{release_path}/src" 
  end
end

namespace :nginx do
  desc "restart nginx server"
  task :restart do
    run "service nginx restart"
  end
end

###########################################################

after "deploy:create_symlink", 	"symlink:src"  
after "deploy:create_symlink", 	"nginx:restart"                  