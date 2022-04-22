class MetricsController < ApplicationController
  def index
    @kanban = current_user.kanbans.find(params[:kanban_id])
    @graph_columns = @kanban.kanban_columns.where({ name: ["WISHLIST", "APPLIED", "INTERVIEW", "OFFER RECIEVED"]}).each
    @jobs = @kanban.cards.order(updated_at: :desc)
  end
end
