VMC_APP_NAME = "cf-rake-sinatra"

require 'rspec/core/rake_task'
require 'cucumber/rake/task'

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
RSpec::Core::RakeTask.new(:spec)

namespace :coverage do
  desc "run rspec code coverage"
  task :spec do
    ENV['COVERAGE'] = "true"
    Rake::Task[:spec].execute
  end

  desc "run cucumber code coverage"
  task :feature do
    ENV['COVERAGE'] = "true"
    Rake::Task[:features].execute
  end
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format progress"
end

namespace :vmc do
  desc "update cloud foundry deployment"
  task :update => [:bundle, :spec, :features] do
    sh "vmc update #{VMC_APP_NAME}"
  end

  desc "get application status"
  task :status do
    sh "vmc stats #{VMC_APP_NAME}"
  end
end

namespace :git do
  desc "push changes to github"
  task :push => [:spec, :features] do
    outstanding_changes?
    sh "git push"
  end

  desc "pull changes from github (with rebase)"
  task :pull => [:spec, :features] do
    sh "git pull --rebase"
  end
end
