class CommentsController < InheritedResources::Base
  def create
    @comment = Comment.new(params[:comment])
    if debate_id = params[:debate][:id]
      debate = Debate.where(:id => debate_id).first
      @comment.commentable = debate
    end
    @comment.member = current_member

    if @comment.save
      if request.xhr?
        render :partial => "debates/comment", :layout => false, :locals => { :comment => @comment }
      else
        flash[:notice] = "Comment successfully saved"
        redirect_to debate_path(debate)
      end
    else 
      if request.xhr?
        render :json => @comment.errors, :status => :unprocessable_entity
      else
        flash[:notice] = "Comment could not be saved"
        redirect_to debate_path(debate)
      end
    end
  end
end
