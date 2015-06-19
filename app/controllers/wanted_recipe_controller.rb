class WantedRecipeController < ApplicationController
  before_filter :authenticate_user!

  def list
    @recipes = current_user.wanted_recipes
    set_menu :wanted

    render 'wanted_recipe/index'
  end

  def create
    current_user.wanted_recipes << Recipe.find(params[:id])
    current_user.save

    redirect_to referer, flash: { notice: t('wanted_recipe.created') }
  end

  def delete
    current_user.wanted_recipes.destroy Recipe.find(params[:id])

    redirect_to referer, flash: { notice: t('wanted_recipe.deleted') }
  end
end
