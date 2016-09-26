class FrontendController < ApplicationController
  def show
    render text: nil, layout: true
  end
end
