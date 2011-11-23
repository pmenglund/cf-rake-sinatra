VMC_APP_NAME = "cf-rake-sinatra"

require 'rspec/core/rake_task'

$:.unshift(File.dirname(__FILE__))

def run(cmd, msg)
  `#{cmd}`
  if $?.exitstatus != 0
    puts msg
    exit 1
  end
end

def outstanding_changes?
  run "git diff-files --quiet", "You have outstanding changes. Please commit them first."
end

task :default => [:run]

desc "run sinatra app locally"
task :run => "Gemfile.lock" do
  require 'app'
  Sinatra::Application.run!
end

desc "bundle ruby gems"
task :bundle => "Gemfile.lock"

# need to touch Gemfile.lock as bundle doesn't touch the file if there is no change
file "Gemfile.lock" => "Gemfile" do
  sh "bundle && touch Gemfile.lock"
end

desc "run specs"
RSpec::Core::RakeTask.new

namespace :vmc do
  desc "update cloud foundry deployment"
  task :update => [:bundle, :spec] do
    sh "vmc update #{VMC_APP_NAME}"
  end

  desc "get application status"
  task :status do
    sh "vmc stats #{VMC_APP_NAME}"
  end
end

namespace :git do
  desc "push changes to github"
  task :push => :spec do
    outstanding_changes?
    sh "git push"
  end

  desc "pull changes from github (with rebase)"
  task :pull => :spec do
    sh "git pull --rebase"
  end
end
