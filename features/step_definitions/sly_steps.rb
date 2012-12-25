require 'fileutils'

include FileUtils

ARUBA_PREFIX = "aruba/tmp/"

When /^I get help for "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} help`)
end

When /^I run the "(.*?)" (.*?) command$/ do |app_name, command|
  @app_name = app_name
  step %(I run `#{app_name} #{command}` interactively)
end

When /^I fill in my username$/ do
  step %(I type "#{ENV["sprintly_email"]}")
end

When /^I fill in my api key$/ do
  step %(I type "#{ENV["sprintly_api_key"]}")
end

And /^I should have a "([^"]*)" file in my home directory$/ do |file_name|
  File.exists?(ENV["HOME"]+"/"+file_name).should be_true
end

Given /^I have already set up Sly$/ do
  steps %Q{
    When I run the "sly" install command
    And I fill in my username
    And I fill in my api key
    Then the stdout should contain "Thanks! Your details are currently stored in ~/.slyrc to authorise your interactions using the Sprint.ly CLI"
  }
end

Given /^I do not have a "(.*?)" file in my home directory$/ do |file_name|
  File.delete(ENV["HOME"]+"/"+file_name) if File.exists?(ENV["HOME"]+"/"+file_name)
end

Given /^I am in a new project folder$/ do
  project_folder = "project"
  mkdir "tmp/aruba/project"
  cd project_folder
  p Dir.pwd
end

When /^I select the intended project option$/ do
  step %{I type "#{ENV["sprintly_product_id"]}"}
end

Then /^I should have a \.sly file in my project folder$/ do
  p pwd
  File.exists?("tmp/aruba/project/.sly").should be_true
end

Then /^I should see my stored project name in the stdout$/ do
  step %{Then the stdout should contain "#{ENV["sprintly_product_name"]}"}
end
