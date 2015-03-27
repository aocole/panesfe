class SlidesController < ApplicationController
  before_action :set_presentation_from_param, only: [:index, :new, :create]
  before_action :set_presentation_from_slide, only: [:show, :destroy]

  def index
  end

  def show
  end

  def create
    last_slide = nil
    params[:files].each do |file|
      last_slide = @presentation.slides.build
      last_slide.image = file
    end
    @presentation.save!
    redirect_to(last_slide ? slide_path(last_slide) : presentation_slides_path(@presentation))
  end

  def destroy
    # need to save the filename somewhere so we can return it in the response
    @name = @slide.name

    @slide.destroy

    respond_to do |format|
      format.html { redirect_to edit_presentation_url(@presentation), notice: 'Slide was successfully destroyed.' }
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
