set :stage, :vagrant
set :puma_env, :vagrant

puts "Setting user to vagrant"

set :rails_env, "vagrant"
set :user, 'vagrant'
set :runner, 'vagrant'
set :tmp_dir, '/home/vagrant/tmp'
set :password, 'vagrant'
set :deploy_via, :copy
set :copy_exclude, ["log", "tmp", ".git", '.tags', '.tags_sorted_by_file', '.gemtags']
set :keep_releases, 5

set :puma_workers, 1

options = {
  :user => 'vagrant', :password => 'vagrant', :tmp_dir => '/home/vagrant/tmp'
}

set :domain, "sprockets-master"
server 'sprockets-master', options.merge(:roles => [:app, :web, :db])
