class Ajax::RecipeController < ApplicationController

  def text_nodes
    node = RecipeTextNode.new image_params

    render :json => { cache: node.image_cache }
  end

  protected
  def image_params
    params.permit(:image)
  end
end

