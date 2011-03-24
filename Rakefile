task :default do
  puts "Install and/or run a benchmark."
  puts
  class << Rake.application; public :display_tasks_and_comments; end
  Rake.application.options.show_task_pattern = //
  Rake.application.display_tasks_and_comments
  puts
  puts "Available servers are: #{SERVERS}"
end

desc "Install required gems and JMeter."
task :install => [:install_gems, :build_git_gems, :install_jmeter, :install_torquebox]

desc "Start a server and run the JMeter driver against it."
task :bench, :server do |t, args|
  server_thread = start_server(args[:server])
  server_thread.join
end

desc "Runs a server."
task :server, :server do |t, args|
  server_thread = start_server(args[:server])
  server_thread.join
end

desc "Runs JMeter."
task :jmeter => :install_jmeter do
  sh "./build/jakarta-jmeter-2.4/bin/jmeter -t srack.jmx"
end

### INSTALL tasks

task :install_gems do
  puts "Installing and bundling gems..."
  ruby *%w(-S maybe_install_gems bundler)
  ruby *%w(-S bundle install)
end

task :build_git_gems do
  kirk = `ruby -S bundle show kirk`.chomp
  aspen = `ruby -S bundle show aspen`.chomp

  unless File.exists?("#{kirk}/lib/kirk/native.jar")
    puts "Building Kirk..."
    Dir.chdir(kirk) do
      ruby *%w(-S rake jar)
    end
  end

  unless File.exists?("#{aspen}/javalib/target/aspenj-1.0-SNAPSHOT.jar")
    puts "Building Aspen..."
    Dir.chdir("#{aspen}/javalib") do
      sh "mvn package"
    end
  end
end

directory 'build'

### TorqueBox

TORQUEBOX_BUILD = '2193'
ENV['TORQUEBOX_BUILD'] = TORQUEBOX_BUILD

file 'build/torquebox-dev.zip' do
  puts "Downloading TorqueBox dev build..."
  # TorqueBox's TeamCity ci server has this extra guest-login crap...
  cookies = '-L --cookie build/cookies --cookie-jar build/cookies'
  sh "curl #{cookies} 'http://ci.stormgrind.org/guestLogin.html?guest=1'"
  sh "curl #{cookies} -o build/torquebox-dev.zip 'http://ci.stormgrind.org/repository/download/bt7/#{TORQUEBOX_BUILD}:id/torquebox-dist-bin.zip'"
end

file 'build/torquebox-1.0.0.CR1-SNAPSHOT/jboss/bin/run.sh' => 'build/torquebox-dev.zip' do |t|
  Dir.chdir('build') do
    sh "unzip -qq -o torquebox-dev.zip" do |ok, res|
    end
  end
  touch t.name                # make sure run.sh is newer than zipfile
end

if ENV['TORQUEBOX'] == 'no'
  task :install_torquebox do
    mkdir_p 'build/torquebox-1.0.0.CR1-SNAPSHOT/jboss/bin'
    touch 'build/torquebox-1.0.0.CR1-SNAPSHOT/jboss/bin/run.sh'
  end
else
  task :install_torquebox => 'build/torquebox-1.0.0.CR1-SNAPSHOT/jboss/bin/run.sh'
end

### JMeter

file 'build/jakarta-jmeter-2.4/bin/jmeter' do
  puts "Installing JMeter..."
  Dir.chdir('build') do
    sh "curl http://www.apache.org/dist/jakarta/jmeter/binaries/jakarta-jmeter-2.4.tgz | tar zxf -"
  end
end

task :install_jmeter => 'build/jakarta-jmeter-2.4/bin/jmeter'

### Start servers

SERVERS = 'aspen kirk mizuno trinidad'

def server_pid
  @server_pid
end

def start_server(server)
  ENV['JRUBY_OPTS'] ||= ''
  ENV['JRUBY_OPTS'] += ' --server --manage'
  server_start_cmd = case server
  when 'aspen'
    'bundle exec aspen start -R config.ru'
  when 'kirk'
    'bundle exec kirk start'
  when 'mizuno'
    'bundle exec mizuno -p 3000 > /dev/null 2>&1'
  when 'trinidad'
    'bundle exec trinidad -r'
  else
    puts "unknown server: #{server}"
    puts "servers are: #{SERVERS}"
    fail
  end

  bin_path = ENV['PATH'].split(File::PATH_SEPARATOR).detect {|p| File.exists?(File.join(p, server))}
  fail "unable to find `#{server}' script on PATH" unless bin_path
  server_script = File.join(bin_path, server)

  server_thread = Thread.new { sh server_start_cmd }
  count = 0
  @server_pid = nil
  loop do
    sleep 1
    `jps -m`.each_line do |l|
      next unless l =~ /#{server_script}/
      @server_pid = l.to_i
      break
    end
    count += 1
    break if @server_pid || count > 4
  end

  fail "Server PID not found after 4 seconds" unless @server_pid
  puts "Server started, PID = #{@server_pid}"
  server_thread
end

at_exit do
  if server_pid
    puts "Killing the server"
    sh "kill #{server_pid}"
  end
end
