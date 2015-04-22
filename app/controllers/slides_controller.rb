class SlidesController < ApplicationController
  before_action :set_presentation_from_param, only: [:index, :new, :create]
  before_action :set_presentation_from_slide, only: [:show, :destroy]

  def index
  end

  def show
  end

  def create
    @slide = nil
    slides = params[:files].collect do |file|
      @slide = @presentation.slides.build
      @slide.image = file
      @slide
    end
    
    @presentation.save

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
        redirect_to edit_presentation_url(@presentation), notice: 'Slide was successfully destroyed.'
      }
      format.json
    end

  end

  private

  def set_presentation_from_param
    @presentation = policy_scope(Presentation).find_by_id!(params[:presentation_id])
    authorize(@presentation)
  end

  def set_presentation_from_slide
    @slide = policy_scope(Slide).find_by_id!(params[:id])
    @presentation = @slide.presentation
    authorize(@presentation)
  end

end
