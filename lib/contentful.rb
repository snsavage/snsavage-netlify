require 'contentful'
require 'pp'
require 'pry'

space_id = 'uvpiph8ym0lw'
access_token = '284ee51823a4d6883fed7ab67e2ee4aa6fa55e13233681c8cfa5efc109e44543'

client = Contentful::Client.new(
  space: space_id,
  access_token: access_token,
  dynamic_entries: :auto
)

Pry.start

