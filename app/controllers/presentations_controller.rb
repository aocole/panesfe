class PresentationsController < ApplicationController
  PANESD_METHODS = [:display, :next, :card, :mark_broken]
  skip_after_action :verify_authorized, only: PANESD_METHODS
  skip_before_action :authenticate_user!, only: PANESD_METHODS
  before_action :verify_localhost, only: PANESD_METHODS
  before_action :set_presentation, only: [:show, :push, :edit, :update, :destroy]

  # This is needed to be able to download .js files from foldershows
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

  def mark_broken
    message = params[:message].to_s
    unless Presentation::BROKEN_MESSAGE_KEYS.include?(message)
      render(status: :bad_request, plain: "Invalid message")
      return
    end

    presentation = Presentation.find_by_id!(params[:id])
    presentation.mark_broken!(message)
    render(nothing: true, status: :no_content)
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

  # push whatever presentation is associated with given card id
  def card
    user = User.find_by_card_number(params[:card])
    unless user
      logger.warn "No user registered with card number: #{params[:card]}"
      render nothing: true
      return
    end
    @presentation = user.primary_presentation || user.presentations.first
    render(nothing: true) unless @presentation
    push
  end

  def push
    begin
      panesfe_endpoint = URI.parse GrowingPanes.config['panesfe_endpoint']
      Panesd.new(display_presentation_url(@presentation, host: panesfe_endpoint.host, port: panesfe_endpoint.port)).push
    rescue Errno::ECONNREFUSED
      flash[:error] = t('controllers.presentations.panesd_offline')
    else
      flash[:notice] = t('controllers.presentations.presentation_pushed')
    end
    redirect_to action: :index
  end

  # GET /presentations/1/display
  def display(previewing=false)
    presentation = Presentation.find_by_id!(params[:id])
    authorize presentation if previewing
    case presentation
    when Slideshow
      respond_to do |format|
        format.html do
          content = presentation.theme.content
          if previewing
            content = content.sub('</body>',
              '<script src="/javascripts/growingpanes.js"></script></body>')
          end
          render html: content.html_safe
        end
        format.json { render json: presentation.slides.rank(:row_order) }
      end
    when Foldershow

      if params[:path].blank?
        the_index = presentation.find_index
        if the_index
          redirect_to path: the_index, trailing_slash: previewing
        else
          presentation.mark_broken!(:no_index_found)
          redirect_to next_presentations_url
        end
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
          render template: 'static/not_found', status: 404
        end
      end

    else
      raise "Don't know how to display #{presentation.inspect}"
    end
  end

  def preview
    display(true)
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

  def verify_localhost
    return true if request.host == 'localhost'
    user_not_authorized
    return false
  end
end
