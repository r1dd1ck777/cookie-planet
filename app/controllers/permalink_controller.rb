class PermalinkController < ApplicationController
  def show1
    slug = request[:slug]

    recipe_tag = RecipeTag.find_by slug: slug
    if recipe_tag
      recipe_tag_show recipe_tag
      return nil
    end

    recipe = Recipe.find_by id: slug
    if recipe
      recipe_show recipe
      return nil
    end

    redirect_to root_path
  end

  def search
    @recipes = Recipe.search(params[:q])

    render 'recipe/search'
  end

  def recipe_show recipe
    @recipe = recipe
    @recipe_json = recipe_json @recipe
    user = current_user
    if user && user.id != @recipe.user_id
      @recipe.views_count = @recipe.views_count + 1
      @recipe.save
      user.watched_recipes << @recipe unless user.watched_recipes.include? @recipe
      user.save!
    end
    apply_meta_tags @recipe

    render 'recipe/show'
  end

  def recipe_tag_show recipe_tag
    @recipe_tag = recipe_tag
    @recipes = @recipe_tag.recipes.page(params[:page]).per(60)
    set_menu recipe_tag.menu_key
    apply_meta_tags @recipe_tag

    render 'recipe/index'
  end
end
