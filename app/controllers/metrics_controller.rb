class MetricsController < ApplicationController
  def index
    @kanban = current_user.kanbans.find(params[:kanban_id])
  end
end
