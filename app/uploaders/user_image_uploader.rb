# encoding: utf-8

class UserImageUploader < BaseImageUploader
  process :resize_to_limit => [750, 750]

  version :list do
    process :resize_to_limit => [345, 345]
  end

  version :small do
    process :resize_to_limit => [60, 60]
  end
end
