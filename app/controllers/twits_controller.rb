class TwitsController < ApplicationController

  def index
    @twits = Twit.order(engagement: :desc)
    if params[:filter_by].present? && params[:start].present? && params[:end].present?
      @twits = Twit.filter(params[:filter_by]).where(params[:filter_by] => params[:start]..params[:end])
    else
      @twits = Twit.order(engagement: :desc)
    end
  end

end
