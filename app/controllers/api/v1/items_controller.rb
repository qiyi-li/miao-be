class Api::V1::ItemsController < ApplicationController
    def index
        p 'index 访问了'
        p params
        items = Item.page(params[:page]).per(params[:num])
        render json:{
            resources:items,
            pager:{
                page:params[:page],
                num:params[:num],
                count:Item.count
            }
        }
    end
    def create
        item = Item.new amount:1
        if item.save
            render json:{resource:item}

        else 
            render json:{errors:item.errors}
        end
    end
end 
