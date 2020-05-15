class HomepagesController < ApplicationController
  def index
    @works = Work.all
  end
end
