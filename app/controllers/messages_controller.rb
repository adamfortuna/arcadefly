class MessagesController < ResourceController::Base
  belongs_to :profile
#  before_filter :can_send, :only => :create


  index.wants.html { 
    render :template => "profiles/messages" 
  }  

  def new
    current_receiver = params[:to] ? Profile.find_by_display_name(params[:to]) : Profile.new
    @message = Message.new({:sender => current_profile, :receiver => current_receiver})
    @profile = parent_object
  end
  
  # def index
  #   @message = Message.new
  #   @to_list = @p.friends
  #   
  #   if @p.received_messages.empty? && @p.has_network?
  #     flash[:notice] = 'You have no mail in your inbox.  Try sending a message to someone.'
  #     @to_list = (@p.followers + @p.friends + @p.followings)
  #     redirect_to new_profile_message_path(@p) and return
  #   end
  # end
  # 
  # def create
  #   @message = @p.sent_messages.create(params[:message]) 
  #   
  #   respond_to do |wants|
  #     if @message.new_record?
  #       wants.js do
  #         render :update do |page|
  #           page.alert @message.errors.to_s
  #         end
  #       end
  #     else
  #       wants.js do
  #         render :update do |page|
  #           page.alert "Message sent."
  #           page << "jq('#message_subject, #message_body').val('');"
  #           page << "tb_remove()"
  #         end
  #       end
  #     end
  #   end
  # end
  # 
  # def new
  #   @message = Message.new
  #   @to_list = (@p.followers + @p.friends + @p.followings)
  #   render
  # end
  # 
  # 
  # def sent
  #   @message = Message.new
  #   @to_list = @p.friends
  # end
  # 
  # def show
  #   @message = @p.sent_messages.find params[:id] rescue nil
  #   @message ||= @p.received_messages.find params[:id] rescue nil
  #   @to_list = [@message.sender]
  # end
  


  protected
  
  def collection
    parent_object.received_messages.paginate(options)
  end
  
  # Setup up the possible options for getting a collection, with defaults
  def options
    search = params[:search] 
    search = "%" + search if search and params[:search].length >= 2

    collection_options = {}
    collection_options[:page] = params[:page] || 1
    collection_options[:per_page] = params[:per_page] || Message::PER_PAGE
    collection_options[:order] = params[:order] || 'messages.created_at desc'
    collection_options
  end
  
  
  def parent_object
    if !current_profile.administrator? || !(params[:profile_id] == current_profile.permalink)
      redirect_to root_url and return
    end
    Profile.find_by_permalink(params[:profile_id])
  end
end
