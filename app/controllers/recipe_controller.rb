class RecipeController < ApplicationController
  before_filter :authenticate_user!
  # before_action :set_food_selects, exept: [:list, :update]

  def new
    @recipe = Recipe.new
    @recipe_json = recipe_json @recipe
  end

  def create
    @recipe = Recipe.new new_recipe_params
    @recipe.user = current_user
    @recipe_json = recipe_json @recipe

    if @recipe.save
      redirect_to permalink_path(@recipe), flash: {notice: t('recipe.created')}
    else
      render 'new'
    end
  end

  def edit
    @recipe = current_user.recipes.find(params[:id])
    @recipe_json = recipe_json @recipe

    render 'new'
  end

  def update
    @recipe = current_user.recipes.find(params[:id])

    @recipe.assign_attributes new_recipe_params

    if @recipe.save
      redirect_to permalink_path(@recipe), flash: {notice: t('recipe.updated')}
    else
      set_food_selects
      render 'new'
    end
  end

  def delete
    @recipe = current_user.recipes.find(params[:id])
    @recipe.destroy

    redirect_to root_path, flash: {notice: t('recipe.deleted')}
  end

  def my_list
    set_menu :my_recipes
    @recipes = current_user.recipes
  end

  def watched
    set_menu :watched
    @recipes = current_user.watched_recipes
  end

  protected

  def set_food_selects
    @foods = Food.all.includes(:food_weights)
    @foods_json = @foods.to_json include: [:food_price, :food_weights, :food_value]
  end

  def recipe_params
    params.require(:recipe).permit(
        :title, :text, :kg, :duration, :image, :image_cache, :remove_image, recipe_tag_ids:[],
        components_attributes: [ :count, :food_id, :count_type, :_destroy, :id],
        food_value_attributes: [:id, :energy, :protein, :fat, :sugar, :sugar_index ],
        recipe_text_nodes_attributes: [:id, :node, :text, :image, :image_cache, :remove_image, :_destroy ]
    )
  end

  def new_recipe_params
    new_recipe_hash = recipe_params
    new_recipe_hash[:text] = ActionView::Base.white_list_sanitizer.sanitize new_recipe_hash[:text]
    new_recipe_hash[:components_attributes].each do |c|
      c = c[1]
      if c[:food_id].to_i == 0 || Food.find_by(id: c[:food_id].to_i).nil?
        food = Food.create name: c[:food_id], user: current_user, is_moderated: false
        c[:food_id] = food.id
      end
    end

    new_recipe_hash
  end
end
