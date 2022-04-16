class CardsController < ApplicationController
  before_action :set_kanban
  before_action :set_card, only: [:edit, :update, :destroy]

  def new
    @kanban_column = @kanban.kanban_columns.find(params[:kanban_column_id])
    @card = @kanban.cards.build
  end

  def create
    @card = @kanban.cards.build(card_params)

    if @card.save
      redirect_to @kanban, notice: 'Card was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      redirect_to @kanban, notice: 'Card was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @card.destroy
    redirect_to @kanban, notice: 'Card was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_card
    @card = @kanban.cards.find(params[:id])
  end

  def set_kanban
    @kanban = current_user.kanbans.find(params[:kanban_id])
  end

  # Only allow a list of trusted parameters through.
  def card_params
    params.require(:card).permit(:content, :position, :kanban_column_id)
  end
end
