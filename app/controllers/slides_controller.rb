class SlidesController < ApplicationController
  before_action :set_slideshow_from_param, only: [:index, :new, :create]
  before_action :set_slideshow_from_slide, only: [:show, :destroy, :update]

  def index
  end

  def show
  end

  def create
    @slide = nil
    slides = params[:files].collect do |file|
      @slide = @slideshow.slides.build
      @slide.image = file
      @slide
    end
    
    @slideshow.save

    # There's some wonky behavior required by jquery-file-upload. It only uploads one
    # file at a time, and we need to return a scalar response in that case
    if slides.size == 1
      if @slide.errors.size > 0
        render json: {files: [{
          error: @slide.errors.full_messages.join(" "), 
          name: params[:files].first.original_filename, 
          size: params[:files].first.size
        }]}
      else
        render action: :show
      end
    else
      render action: :index
    end
  end

  def destroy
    # need to save the filename somewhere so we can return it in the response
    @name = @slide.name

    @slide.destroy

    respond_to do |format|
      format.html { 
        redirect_to edit_slideshow_url(@slideshow), notice: 'Slide was successfully destroyed.'
      }
      format.json
    end

  end

  # This is only used to update row order
  def update
    @slide.row_order_position = slide_params[:row_order_position]
    if @slide.save
      render nothing: true
    else
      render json: {files: [{
        error: @slide.errors.full_messages.join(" ")
      }]}, status: 400
    end
  end

  private

  def set_slideshow_from_param
    @slideshow = policy_scope(Slideshow).find_by_id!(params[:slideshow_id])
    authorize(@slideshow)
  end

  def set_slideshow_from_slide
    @slide = policy_scope(Slide).find_by_id!(params[:id])
    @slideshow = @slide.slideshow
    authorize(@slideshow)
  end

  def slide_params
    params.require(:slide).permit(:id, :row_order_position)
  end
end
