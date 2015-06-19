class MetaTag < ActiveRecord::Base
  belongs_to :meta_tags_able, polymorphic: true
end
