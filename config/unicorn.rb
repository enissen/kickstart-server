# Path to app that will be configured by unicorn, 
# note the trailing slash in this example
@dir = "/home/atlas/kickstart-server/"

worker_processes 4
working_directory @dir

timeout 30

# Specify path to socket unicorn listens to, 
# Will be used in nginx.conf later
listen "#{@dir}tmp/sockets/unicorn.sock", :backlog => 64

# Set process id path
pid "#{@dir}tmp/pids/unicorn.pid"

# Set log file paths
stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"