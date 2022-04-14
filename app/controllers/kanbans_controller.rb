class KanbansController < ApplicationController
  before_action :set_kanban, only: [:show, :edit, :update, :destroy]

  # GET /kanbans
  def index
    @kanbans = Kanban.all
  end

  # GET /kanbans/1
  def show
  end

  # GET /kanbans/new
  def new
    @kanban = Kanban.new
  end

  # GET /kanbans/1/edit
  def edit
  end

  # POST /kanbans
  def create
    @kanban = Kanban.new(kanban_params)

    if @kanban.save
      redirect_to @kanban, notice: 'Kanban was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /kanbans/1
  def update
    if @kanban.update(kanban_params)
      redirect_to @kanban, notice: 'Kanban was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /kanbans/1
  def destroy
    @kanban.destroy
    redirect_to kanbans_url, notice: 'Kanban was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kanban
      @kanban = Kanban.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kanban_params
      params.require(:kanban).permit(:name, :description)
    end
end
