ActiveAdmin.register Food do

  permit_params :name, :image, :image_cache, :count_type_preset, :is_moderated,
                food_weights_attributes: [:id, :kg, :count_type, :_destroy],
                food_prices_attributes: [:id, :price, :count_type, :currency ],
                food_value_attributes: [:energy, :protein, :fat, :sugar, :sugar_index ]

  form do |f|
    f.inputs do
      f.input :name
      f.input :is_moderated
      f.input :count_type_preset
      f.input :image, :as => :file, required: false, :hint => f.object.image.default? ? '' : f.template.image_tag(f.object.image.url(:list))
      f.input :image_cache, :as => :hidden
      f.has_many :food_weights, allow_destroy: true, new_record: true do |cf|
        cf.input :kg, as: :string
        cf.input :count_type, as: :select, collection: CountTypeHelper.select_options(:price)
      end
      f.has_many :food_prices, allow_destroy: true, new_record: true do |cf|
        cf.input :price, as: :string
        cf.input :currency, as: :select, collection: AppCurrency.currencies
        cf.input :count_type, as: :select, collection: CountTypeHelper.select_options(:price)
      end
      f.inputs "Состав", :for => [:food_value, f.object.food_value ] do |food_value_form|
        food_value_form.input :energy, as: :string
        food_value_form.input :protein, as: :string
        food_value_form.input :fat, as: :string
        food_value_form.input :sugar, as: :string
        food_value_form.input :sugar_index, as: :string
      end
    end
    f.actions
  end

  show do |ad|
    attributes_table do
      row :id
      row :name
      row :image do
        tag("img", src: ad.image.url(:list))
      end
    end
  end

  index do
    column :id
    column :name
    # column :image do |o|
    #   image_tag(o.image.url(:list))
    # end
    actions
  end

end
