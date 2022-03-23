require 'json'
require 'open-uri'

class BaseController < ApplicationController
  def home
    @page = if params[:page].present? && params[:page].to_i.positive?
              params[:page].to_i
            else
              1
            end

    @sort = if params[:sort].present? && defined?(params[:sort])
              params[:sort]
            else
              'name'
            end

    puts @sort
    @packsinfos = if params[:query].present?
                    packtotal = if @sort == 'stars'
                                  getinfo(params[:query]).sort_by! { |e| -e[@sort] }

                                elsif @sort == 'name' || @sort == 'repository_url'
                                  getinfo(params[:query]).sort_by! { |e| e[@sort].downcase }

                                end
                    packtotal[((@page - 1) * 5)...(@page * 5)]

                  elsif @sort == 'stars'
                    getinfo('').sort_by! { |e| -e[@sort] }[((@page - 1) * 5)...(@page * 5)]
                  else

                    getinfo('').sort_by! { |e| e[@sort].downcase }[((@page - 1) * 5)...(@page * 5)]

                  end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'partials/all_cards', locals: { pack: @packsinfos }, formats: [:html] }
    end
  end

  private

  def getinfo(search)
    url = "https://libraries.io/api/bower-search?q=#{search}"
    packs_serialized = URI.open(url).read
    JSON.parse(packs_serialized)
  end
end
