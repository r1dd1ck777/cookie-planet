ActiveAdmin.register RecipeTag do

  permit_params :name, :image, :image_cache, :remove_image

  form do |f|
    f.inputs do
      f.input :name
      f.input :slug

      f.input :image, as: :file, :hint => f.object.image.default? ? '' : f.template.image_tag(f.object.image.url(:list))
      f.input :image_cache, as: :hidden
      f.input :remove_image, as: :boolean
    end
    f.actions
  end
  
end
