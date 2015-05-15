class SlideshowsController < ApplicationController
  before_action :set_slideshow, only: [:show, :push, :edit, :update, :destroy]

  # GET /slideshows/new
  def new
    @slideshow = Slideshow.new
    authorize @slideshow
    @slideshow.slides.build
    if params[:theme_id]
      @slideshow.theme = policy_scope(Theme).find_by_id(params[:theme_id])
    end
  end

  # GET /slideshows/1/edit
  def edit
    @slideshow.slides.build
  end

  # POST /slideshows
  # POST /slideshows.json
  def create
    @slideshow = Slideshow.new(user: current_user)
    @slideshow.assign_attributes(slideshow_params)
    authorize @slideshow

    respond_to do |format|
      if @slideshow.save
        format.html { redirect_to edit_slideshow_path(@slideshow), notice: t('controllers.slideshows.created_flash') }
        format.json { render :show, status: :created, location: @slideshow }
      else
        format.html { render @slideshow.slideshow? ? :new : :new_folder }
        format.json { render json: @slideshow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /slideshows/1
  # PATCH/PUT /slideshows/1.json
  def update
    respond_to do |format|
      if @slideshow.update(slideshow_params)
        format.html { redirect_to presentations_path, notice: 'Presentation was successfully updated.' }
        format.json { render :show, status: :ok, location: @slideshow }
      else
        format.html { render :edit }
        format.json { render json: @slideshow.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slideshow
      @slideshow = policy_scope(Slideshow).find_by_id!(params[:id])
      authorize @slideshow
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slideshow_params
      params.require(:slideshow).permit(:name, :published, :theme_id, slides_attributes: [:id, :image, :_destroy])
    end
 
end
