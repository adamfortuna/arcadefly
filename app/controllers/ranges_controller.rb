class RangesController < ResourceController::Base
  
  def create
    if params[:session][:arcade_range]
      current_session.arcade_range = params[:session][:arcade_range]
    elsif params[:session][:profile_range]
      current_session.profile_range = params[:session][:profile_range]
    end

    respond_to do |format|
      format.js { head :ok}
      format.html { redirect_to link_without_page(request.env["HTTP_REFERER"]) }
    end
  end

end