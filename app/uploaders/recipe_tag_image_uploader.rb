# encoding: utf-8

class RecipeTagImageUploader < BaseImageUploader
  version :list do
    process :resize_to_limit => [345, 345]
  end
end
