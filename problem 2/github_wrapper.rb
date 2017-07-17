require "github_api"


class GithubWrapper

  class << self
    attr_accessor :github_client,:default_repo,:default_org_name

    def client(token,default_repo,default_org_name)
      self.github_client ||=  Github.new do |config|
        config.oauth_token = token
        config.adapter     = :net_http
      end
      self.default_repo = default_repo
      self.default_org_name = default_org_name
    end

    def find_commit_date(branch,repo_name=nil,org_name=nil)
      repo_name ||= default_repo
      org_name ||= default_org_name
      begin
        result = self.github_client.repos.commits.get org_name,repo_name,branch
        result.body.commit.author.date
      rescue Github::Error::NotFound  => e
        puts "this feature branch doesn't exist anymore #{branch}"
      end
    end
  end
end
