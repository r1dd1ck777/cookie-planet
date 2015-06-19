ActiveAdmin.register Recipe do

  permit_params :title, :user_id, recipe_tag_ids:[],
                components_attributes: [:id, :count, :count_type, :food_id, :_destroy],
                food_value_attributes: [:energy, :protein, :fat, :sugar, :sugar_index ],
                recipe_text_nodes_attributes: [:node, :text, :image, :image_cache, :remove_image ]

  form do |f|
    f.inputs do
      f.input :recipe_tags
      f.input :title
      f.input :user
      # f.input :slug
      f.has_many :components, allow_destroy: true, new_record: true do |cf|
        cf.input :count
        cf.input :count_type
        cf.input :food
      end
      f.has_many :recipe_text_nodes, allow_destroy: true, new_record: true do |cf|
        cf.input :node
        cf.input :text
        cf.input :image, as: :file, :hint => cf.object.image.default? ? '' : cf.template.image_tag(cf.object.image.url(:list))
        cf.input :image_cache, as: :hidden
        cf.input :remove_image, as: :boolean
      end
      f.inputs "Состав", :for => [:food_value, f.object.food_value ? f.object.food_value : FoodValue.new ] do |food_value_form|
        food_value_form.input :energy, as: :string
        food_value_form.input :protein, as: :string
        food_value_form.input :fat, as: :string
        food_value_form.input :sugar, as: :string
        food_value_form.input :sugar_index, as: :string
      end
      # other fields...
    end
    f.actions
  end
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end
