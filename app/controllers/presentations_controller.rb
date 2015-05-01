class PresentationsController < ApplicationController
  skip_after_action :verify_authorized, only: [:display, :next]
  skip_before_action :authenticate_user!, only: [:display, :next]
  before_action :set_presentation, only: [:show, :push, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:display]

  # GET /presentations
  # GET /presentations.json
  def index
    @presentations = policy_scope(Presentation)
  end

  # GET /presentations/1
  # GET /presentations/1.json
  def show
  end

  # TODO: this could be improved to better "randomize" the selection by 
  # taking recently-played information in to account.
  def next
    offset = rand(Presentation.count)
    presentation = Presentation.offset(offset).select([:id]).first
    if presentation.nil?
      redirect_to logged_out_home_path
      return
    end
    redirect_to display_presentation_url(presentation)
  end

  def push
    begin
      panesfe_endpoint = URI.parse GrowingPanes.config['system']['panesfe_endpoint']
      Panesd.new(display_presentation_url(@presentation, host: panesfe_endpoint.host, port: panesfe_endpoint.port)).push
    rescue Errno::ECONNREFUSED
      flash[:error] = t('controllers.presentations.panesd_offline')
    end
    flash[:notice] = t('controllers.presentations.presentation_pushed')
    redirect_to action: :index
  end

  # GET /presentations/1/display
  def display
    presentation = Presentation.find_by_id!(params[:id])
    case presentation
    when Slideshow
      respond_to do |format|
        format.html { render html: presentation.theme.content.html_safe }
        format.json { render json: presentation.slides }
      end
    when Foldershow
      if params[:path].blank?
        redirect_to path: 'index.html'
        return
      end
      Zip::File.open(presentation.folder_zip.path) do |zipfile|
        tmpfile = Tempfile.new(["presentation_#{presentation.id}_", File.extname(params[:path])])
        overwrite = true # Need this so Rubyzip will write overwrite the (empty) new tmpfile
        zip_entry = zipfile.find_entry(params[:path])
        if zip_entry
          zip_entry.extract(tmpfile.path) { overwrite }
          send_file tmpfile.path, disposition: 'inline'
        else
          render template: 'static/not_found'
        end
      end
    else
      raise "Don't know how to display #{presentation.inspect}"
    end
  end

  # DELETE /presentations/1
  # DELETE /presentations/1.json
  def destroy
    @presentation.destroy
    respond_to do |format|
      format.html { redirect_to presentations_url, notice: 'Presentation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_presentation
      @presentation = policy_scope(Presentation).find_by_id!(params[:id])
      authorize @presentation
    end
end
