require "aws-sdk"
require File.expand_path(File.dirname(__FILE__) + '/github_wrapper.rb')


class Ec2Wrapper


  class << self
    # defining class variables  to store the connection information and
    attr_accessor :ec2_client
    # Intializes the client object
    # stores it in class variable
    def client(region,access_key_id=nil,secret_access_key=nil)
      self.ec2_client ||= Aws::EC2::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key )
    end

    # get the list of instance with filters having tag Branch and instance state running
    def instance_list(next_token=nil)
      self.ec2_client.describe_instances(
        {
          filters: [
            {
            name: "tag:Branch",
            values: ["*"],
            },
            {
              name: "instance-state-name",
              values: ["running"],
            }
          ],
          next_token:  next_token
      })
    end

    def fetch_all_instances
      resp = process_resp
      while resp.next_token !=nil
        resp = process_resp
      end
    end

    def process_resp
      resp = instance_list
      process(resp)
      return resp
    end

    def process(resp)
      current_date = Time.now.to_datetime
      termination_list = []
      resp.reservations.each do |reservation|
        reservation.instances.each do |instance|
          branch = ""
          instance.tags.each do |tag|
            if tag.key == "Branch"
              branch = tag.value 
              break
            end

          end
          # check the latest commit
          if !branch.empty?
            date = GithubWrapper.find_commit_date(branch,nil,nil)
            if date
              commit_date=DateTime.parse(date)
              diff = (current_date-commit_date).to_f
              if  diff > 3
                termination_list.push(instance.instance_id)
              end
            end
          end
        end
      end
      puts "terminating following instances #{termination_list}..."
      terminate(termination_list)
    end

    def terminate(termination_list)
      self.ec2_client.terminate_instances(
        {
          instance_ids: termination_list, # required
          dry_run: false,
      })
    end
  end
end
