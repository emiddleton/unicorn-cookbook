action :create do

  worker_processes = new_resource.worker_processes || [node[:cpu][:total].to_i * 4, 8].min
  config_dir = ::File.dirname(new_resource.config)

  directory config_dir do
    recursive true
    action :create
  end

  listen = {}
  new_resource.listen.each do |port, options|
    oarray = Array.new
    options.each do |k, v|
      oarray << ":#{k} => #{v}"
    end
    listen[port] = oarray.join(", ")
  end

  t =
    template new_resource.config do
      action :nothing
      source "unicorn.rb.erb"
      cookbook "unicorn"
      mode "0644"
      owner new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group
      mode new_resource.mode   if new_resource.mode
      variables :user              => new_resource.user,
                :group             => new_resource.group,
                :listen            => listen,
                :working_directory => new_resource.working_directory,
                :worker_timeout    => new_resource.worker_timeout,
                :preload_app       => false, #new_resource.preload_app,
                :worker_processes  => worker_processes,
                :before_fork       => new_resource.before_fork,
                :after_fork        => new_resource.after_fork,
                :pid               => new_resource.pid,
                :stderr_path       => new_resource.stderr_path,
                :stdout_path       => new_resource.stdout_path
    end
  t.run_action(:create)
  if t.updated?
    Chef::Log.debug "#{new_resource.config} updated"
    @new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug "#{new_resource.config} not updated"
  end
 
  t =
    template "/etc/init.d/unicorn.#{new_resource.name}" do
      action :nothing
      source 'unicorn.initd.erb'
      cookbook 'unicorn'
      owner "root"
      group "root"
      mode "0755"
      variables :name => "unicorn.#{new_resource.name}",
                :need => "net",
                :before => "monit"
    end
  t.run_action(:create)
  if t.updated?
    Chef::Log.debug "/etc/init.d/unicorn.#{new_resource.name} updated"
    @new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug "/etc/init.d/unicorn.#{new_resource.name} not updated"
  end

  t =
    template "/etc/conf.d/unicorn.#{new_resource.name}" do
      action :nothing
      source 'unicorn.confd.erb'
      cookbook 'unicorn'
      owner "root"
      group "root"
      mode "0644"
      variables :app_root            => new_resource.working_directory,
                :unicorn_pid_file    => new_resource.pid,
                :unicorn_config_file => new_resource.config,
                :env                 => new_resource.env
    end
  t.run_action(:create)
  if t.updated?
    Chef::Log.debug "/etc/conf.d/unicorn.#{new_resource.name} updated"
    @new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug "/etc/conf.d/unicorn.#{new_resource.name} not updated"
  end

end
