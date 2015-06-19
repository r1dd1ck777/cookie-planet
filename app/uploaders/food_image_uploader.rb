# encoding: utf-8

class FoodImageUploader < BaseImageUploader
  process :resize_to_limit => [750, 750]

  version :list do
    process :resize_to_limit => [345, 345]
  end
end
