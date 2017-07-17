require File.expand_path(File.dirname(__FILE__) + '/ec2_wrapper.rb')
require File.expand_path(File.dirname(__FILE__) + '/github_wrapper.rb')
Config = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'config.yml'))

class Monitoring

  def scan
    Ec2Wrapper.client(Config["aws"]["region"])
    GithubWrapper.client(Config["github"]["token"],Config["github"]["repo_name"],Config["github"]["org_name"])
    Ec2Wrapper.fetch_all_instances  
  end
end

puts "scanning"
Monitoring.new.scan