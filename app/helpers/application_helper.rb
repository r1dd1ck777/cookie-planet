module ApplicationHelper
  def current_url(overwrite={})
    url_for :only_path => false, :params => params.merge(overwrite)
  end

  def db_partial key
    Partial._ key
  end

  def recipe_slide_class
    case rand(4)
      when 0
        return 'slide-from-l'
      when 1
        return 'slide-from-t'
      when 2
        return 'slide-from-r'
      when 3
        return 'slide-from-b'
    end
  end

  def component_count v
    v == v.to_i ? v.to_i : v
  end

end
