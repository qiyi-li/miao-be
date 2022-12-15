class Api::V1::TagsController < ApplicationController
  def index
    current_user = User.find_by_id request.env["current_user_id"]
    return render status: 401 if current_user.nil?
    tags = Tag.where(user_id: current_user.id).page(params[:page])
    render json: {
      resources: tags,
      pager: {
        page: params[:page] || 1,
        num: Tag.default_per_page,
        count: Tag.count,
      },
    }
  end
  def show
    tag = Tag.find_by_id params[:id]
    if tag.user_id == request.env["current_user_id"]
      return render json: { resource: tag }, status: 200
    else
      return render status: 403
    end
    return render status: 404 if tag.nil?
     
  end

  def create
    current_user = User.find_by_id request.env["current_user_id"]
    return render status: 401 if current_user.nil?

    tag = Tag.new name: params[:name], sign: params[:sign], user_id: current_user.id
    if (tag.save)
      render json: { resource: tag }, status: 200
    else 
      render json: { errors: tag.errors }, status: 422
    end
  end

  def update
    current_user = User.find_by_id request.env["current_user_id"]
    return render status: 401 if current_user.nil?

    tag = Tag.find_by_id params[:id]
    return render status 404 if tag.nil?

    tag.update params.permit(:name, :sign)
    if tag.errors.empty?
      render json: { resource: tag }, status: 200
    else
      render json: { errors: tag.errors }, status: 422
    end
  end
  def destroy
    tag = Tag.find_by_id params[:id]
    if not tag.user_id == request.env["current_user_id"]
      return render status: 403
    end
    return render status: 404 if tag.nil?

    tag.deleted_at = Time.now
    if tag.save
       head 200
    else
      render json: { errors: tag.errors }, status: 422
    end
  end
end
