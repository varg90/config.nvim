#!/usr/bin/env ruby

require 'yaml'
require 'erb'
require 'uri'

yml_path = File.expand_path(ARGV[0] || 'config/database.yml')

unless File.exist?(yml_path)
  warn "File not found: #{yml_path}"
  exit 1
end

raw = ERB.new(File.read(yml_path)).result
config = YAML.safe_load(raw, aliases: true)

%w[development test].each do |env|
  next unless config[env]

  url =
    if config[env]['url']
      config[env]['url']
    else
      adapter = config[env]['adapter'] || 'postgres'
      username = config[env]['username'] || ENV['USER']
      password = config[env]['password']
      host = config[env]['host'] || 'localhost'
      port = config[env]['port'] || 5432
      database = config[env]['database']

      auth = password ? "#{username}:#{password}" : username
      "#{adapter}://#{auth}@#{host}:#{port}/#{database}"
    end

  puts "#{env}=#{url}"
end
