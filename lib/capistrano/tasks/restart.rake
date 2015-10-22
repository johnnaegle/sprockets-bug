namespace :deploy do
  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo /etc/init.d/nginx stop"
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo /etc/init.d/nginx start"
    end
  end

  desc 'Restart application'
  task :restart do
    invoke 'puma:smart_restart'

    on roles(:queue) do
      invoke 'delayed_job:restart'
    end
  end

  after :restart, :clear_cache do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
