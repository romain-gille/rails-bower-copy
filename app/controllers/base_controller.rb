require 'json'
require 'open-uri'

class BaseController < ApplicationController
  def home
    @packages = %w[Bootstrap FontAwesome]
    @packsinfos = getinfo.first(5)
  end

  private

  def getinfo
    url = 'https://libraries.io/api/bower-search?q='
    packs_serialized = URI.open(url).read
    JSON.parse(packs_serialized)
  end
end
