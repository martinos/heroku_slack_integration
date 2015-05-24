require 'github_api'

class GithubAdapter
  def initialize(user: 'rails', project: 'rails', oauth_token: )
    @user = user
    @project = project
    @gh = Github.new(oauth_token: oauth_token)
  end

  def changes(old_sha, new_sha)
    Changes.new(adapter: self, old_sha: old_sha, new_sha: new_sha)
  end

  def diff_url(old, new)
    res = @gh.repos.commits.compare(@user, @project, old, new)
    res.html_url
  end

  def files(old, new)
    res = @gh.repos.commits.compare(@user, @project, old, new)
    res.files.map do |rec| 
      {name: rec.filename, 
       additions: rec[:additions], 
       deletions: rec[:deletions],
       patch: rec[:patch]}
    end
  end
end

class Changes
  def initialize(adapter: ,old_sha: , new_sha: )
    @adapter = adapter
    @old_sha = old_sha
    @new_sha = new_sha
  end

  def diff_url
    @adapter.diff_url(@old_sha, @new_sha)
  end

  def files
    @files ||= @adapter.files(@old_sha, @new_sha)
  end

  def release_notes
    changelog = files.detect {|a| a[:name] =~ /changelog/i}
    changelog && changelog[:patch]
  end
end

