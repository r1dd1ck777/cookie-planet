class StaticPage < ActiveRecord::Base
  has_many :meta_tags, as: :meta_tags_able, :dependent => :destroy

  after_initialize :create_meta_tags

  def meta_title
    self.title
  end

  protected

  def create_meta_tags
    if self.meta_tags.empty?
      self.meta_tags.new(key: :title)
      self.meta_tags.new(key: :description)
      self.meta_tags.new(key: :keywords)
    end
  end
end
