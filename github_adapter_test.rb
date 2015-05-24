require 'minitest/autorun'
require './github_adapter'
require 'pry-nav'

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

