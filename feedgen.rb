#!/usr/bin/env ruby

require 'yaml'
require 'json'
require 'time'

logDir = 'log'
profileFile = 'profile.yml'

outputFile = 'feed.json'

data = []
Dir.glob "#{logDir}/*.yml" do |fname|
  yam = YAML.load_file(fname)
  data.concat yam['data']
end

data = data.sort { |a, b| b['time'] <=> a['time'] }.take(30)

profile = YAML.load( File.open(profileFile, 'r') { |f| f.read } )
json = {}
json['profile'] = profile['profile']
json['portal'] = profile['portal']
json['meta'] = profile['meta']
json['feed'] = []

data.each { |entry|
  res = {}
  entry.each { |key, value|
    res[key] = case key
      when "time"
        Time.parse(value).tv_sec
      else
        value
      end
  }

  json['feed'].push res
}

File.open(outputFile, 'w') { |f| f.write( JSON.dump(json) ) }
