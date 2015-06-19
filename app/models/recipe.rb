class Recipe < ActiveRecord::Base
  # extend FriendlyId
  # friendly_id :title, use: [:slugged, :finders]

  belongs_to :user
  has_and_belongs_to_many :recipe_tags, :join_table => :recipe_to_tag
  has_many :components, :dependent => :destroy
  has_many :recipe_text_nodes, :dependent => :destroy
  has_one :food_value, as: :nutritionable, :dependent => :destroy

  accepts_nested_attributes_for :recipe_tags
  accepts_nested_attributes_for :components, :food_value, :recipe_text_nodes, allow_destroy: true

  mount_uploader :image, RecipeImageUploader

  validates :title, presence: true
  after_initialize :create_food_value

  scope :landing, -> do
    order('created_at desc')
  end

  def self.search(str)
    return [] if str.blank?
    words = str.split

    cond_text = words.map{|w| " title LIKE ? "}.join(" OR ") + ' OR '
    cond_values = words.map{|w| "%#{w}%"}

    cond_text = cond_text + words.map{|w| " recipe_text_nodes.text LIKE ? "}.join(" OR ")
    cond_values = cond_values + words.map{|w| "%#{w}%"}
    joins(:recipe_text_nodes).where(str ? [cond_text, *cond_values] : []).order('created_at desc').uniq
  end

  def meta_title
    "#{title} | #{Settings.seo.title_sufix}"
  end

  def og_image
    image.url(:list)
  end

  def og_description
    "#{title} | #{Settings.seo.title_sufix} на сайте #{Settings.seo.og_hostname}"
  end

  def kg= value
    value = value.gsub(',', '.')
    write_attribute(:kg, value)
  end

  def show_next_recipe
    Recipe.order("id asc").find_by("id > ?", id)
  end

  def show_prev_recipe
    Recipe.order("id desc").find_by("id < ?", id)
  end

  protected
  def create_food_value
    self.food_value = FoodValue.new if food_value.nil?
  end
end
