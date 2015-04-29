class FoldershowsController < ApplicationController
  before_action :set_foldershow, only: [:show, :push, :edit, :update, :destroy]

  # GET /foldershows/new
  def new
    @foldershow = Foldershow.new
    authorize @foldershow
  end

  # GET /foldershows/1/edit
  def edit
  end

  # POST /foldershows
  # POST /foldershows.json
  def create
    @foldershow = Foldershow.new(user: current_user)
    @foldershow.assign_attributes(foldershow_params)
    authorize @foldershow

    respond_to do |format|
      if @foldershow.save
        format.html { redirect_to presentations_path, notice: t('controllers.foldershows.created_flash') }
        format.json { render :show, status: :created, location: @foldershow }
      else
        format.html { render @foldershow.foldershow? ? :new : :new_folder }
        format.json { render json: @foldershow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foldershows/1
  # PATCH/PUT /foldershows/1.json
  def update
    respond_to do |format|
      if @foldershow.update(foldershow_params)
        format.html { redirect_to presentations_path, notice: 'Presentation was updated successfully.' }
        format.json { render :show, status: :ok, location: @foldershow }
      else
        format.html { render :edit }
        format.json { render json: @foldershow.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_foldershow
      @foldershow = policy_scope(Foldershow).find_by_id!(params[:id])
      authorize @foldershow
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def foldershow_params
      params.require(:foldershow).permit(:name, :published, :folder_zip)
    end
 
end
