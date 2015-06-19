class RecipeTag < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_and_belongs_to_many :recipes, -> {order('created_at desc')} ,:join_table => :recipe_to_tag
  mount_uploader :image, RecipeTagImageUploader

  def menu_key
    "RecipeTag##{id}"
  end

  def meta_title
    "#{name} | #{Settings.seo.title_sufix}"
  end
end
