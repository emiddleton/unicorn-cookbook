def initialize(name, run_context=nil)
  super(name, run_context)
  @action = :create
end

actions :create

attribute :user,              :kind_of => String, :required => true
attribute :group,             :kind_of => String, :required => true
attribute :config,            :kind_of => String
attribute :env,               :kind_of => [String,Symbol]
attribute :listen,            :kind_of => Hash
attribute :working_directory, :kind_of => String
attribute :worker_processes,  :kind_of => Integer
attribute :worker_timeout,    :kind_of => Integer, :default => 60

#attribute :preload_app,       :kind_of => [TrueClass,FalseClass], :default => false

attribute :before_fork,       :kind_of => String, :default => 'sleep 1'
attribute :after_fork,        :kind_of => String

attribute :pid,               :kind_of => String
attribute :stderr_path,       :kind_of => String
attribute :stdout_path,       :kind_of => String
attribute :owner,             :kind_of => String
attribute :group,             :kind_of => String
attribute :mode,              :kind_of => String
