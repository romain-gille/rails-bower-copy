require 'json'
require 'open-uri'

class BaseController < ApplicationController
  def home
    @page = if params[:page].present? && params[:page].to_i.positive?
              params[:page].to_i
            else
              1
            end

    @sort = if params[:sort].present?
              params[:sort]
            else
              'name'
            end
    @packsinfos = if params[:query].present?
                    getinfo(params[:query]).sort_by! { |e| e[@sort].downcase }[((@page - 1) * 5)...(@page * 5)]
                  else
                    getinfo('').sort_by! { |e| e[@sort].downcase }[((@page - 1) * 5)...(@page * 5)]
                  end
  end

  private

  def getinfo(search)
    url = "https://libraries.io/api/bower-search?q=#{search}"
    packs_serialized = URI.open(url).read
    JSON.parse(packs_serialized)
  end
end
