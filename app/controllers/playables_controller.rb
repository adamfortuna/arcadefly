class PlayablesController < ResourceController::Base
  belongs_to :arcade
  before_filter :check_claim, :only => [:new, :create, :edit, :update, :destroy]

  # Adding a game to an arcade
  def create
    @arcade = parent_object
    @game = Game.find_by_name(params[:game][:name])

    respond_to do |format|
      format.js {
        begin
          @arcade.playables << Playable.new({:game_id => @game.id, :games_count => params[:count]})
          @playable = @arcade.playables.find_by_game_id(@game.id)
          render
        rescue
          render :update do |page|
            page.alert "There was a problem adding that game. You can only add games that are available from the drop down list. Please make sure it this arcade doesn't already has that game. If you want to update the count, please remove it and re-add it."
            page.call 'Form.reset', 'arcade_form'
          end        
        end
      }
    end
  end
  
  # Updating all the games at an arcade
  def update
    redirect_to root_url
  end

  # DELETE /arcades/:arcade_id/playables/:id
  def destroy
    @playable = parent_object.playables.find(params[:id])
    
    if @playable.destroy
      render :update do |page|
        page.visual_effect :fade, "playable_#{@playable.id}"
      end
    else
      render :update do |page|
        page.alert("Looks like there was a problem removing this game. Please reload the page and try again.")
      end
    end
  end
  
  private
  def parent_object
    Arcade.find_by_permalink(params[:arcade_id])
  end
  
  def check_claim
    permission_denied if !logged_in?
    permission_denied unless current_profile.claimed?(parent_object) || current_profile.administrator?
  end
  
end