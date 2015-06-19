# encoding: utf-8

class RecipeImageUploader < BaseImageUploader
  process :resize_to_limit => [750, 750]

  version :list do
    process :resize_to_limit => [345, 345]
  end
  version :list_square do
    process :resize_to_fill => [230, 170]
  end
end
