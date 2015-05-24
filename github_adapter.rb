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

if $0 != __FILE__ 
require 'minitest/autorun'

describe GithubAdapter do
  before do
    @adapt = GithubAdapter.new(oauth_token: ENV['GITHUB_OAUTH_TOKEN'])
    @old_sha = "db045dbbf60b53dbe013ef25554fd013baf88134"
    @new_sha = "9e4144536051175273daf00461d7c73e6ae20358"
    @changes = @adapt.changes(@old_sha, @new_sha)
  end

  it "extracts html diff html" do
    url = @changes.diff_url
    url.must_equal "https://github.com/rails/rails/compare/db045dbbf60b53dbe013ef25554fd013baf88134...9e4144536051175273daf00461d7c73e6ae20358"
  end

  it "extracts the file that changed" do
    files = @changes.files
    file = files.first
    file[:name].must_equal "actionpack/CHANGELOG"
    file[:additions].must_equal 4 
    file[:deletions].must_equal 0 
    file[:patch].wont_be_nil
  end

  it "extracts the release notes" do
    @changes.release_notes.must_match /form_tag/
  end
end
end
