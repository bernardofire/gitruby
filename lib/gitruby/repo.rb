# encoding: utf-8
require 'httparty'
require File.dirname(__FILE__) + '/user'
require File.dirname(__FILE__) + '/issue'
require File.dirname(__FILE__) + '/util'

class Repo
  include Util

  def initialize(params)
    load_lazing_attrs(params)
  end

  def self.find(owner_login, repository)
    new(HTTParty.get "#{BASE_URL}repos/#{owner_login}/#{repository}")
  end

  def forks(options=nil)
    options = format_options(options)
    params = HTTParty.get "#{BASE_URL}repos/#{@owner['login']}/#{@name}/forks#{options}"
    return params.map { |fork| Repo.new(fork) }
  end

  def collaborators(options=nil)
    options = format_options(options)
    params = HTTParty.get "#{BASE_URL}repos/#{@owner['login']}/#{@name}/collaborators#{options}"
    return params.map { |user| User.new(user) }
  end

  def issues(options=nil)
    options = format_options(options)
    params = HTTParty.get "#{BASE_URL}repos/#{@owner['login']}/#{@name}/issues#{options}"
    return params.map { |issue| Issue.new(issue) }
  end

  def issue(number)
    return Issue.find(@owner['login'], @name, number)
  end
end
