class Ajax::CountTypesController < ApplicationController
  def all
    render :text => CountTypeHelper.to_array_of_objects(:price).to_json
  end
end
