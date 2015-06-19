class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :before_action_cb
  after_action :set_csrf_cookie_for_ng

  extend ActiveModel::Callbacks
  define_model_callbacks :render
  before_render :use_meta_page

  # current menu
  helper_method :menu?
  def menu? key
    @current_menu == key ? 'active' : ''
  end

  def set_menu key
    @current_menu = key
  end
  # /current menu

  # currency
  helper_method :currency_data
  def currency_data
    @currency_data = find_current_currency unless @currency_data
    @currency_data
  end

  def find_current_currency
    if current_user && current_user.currency.present?
      return {
          currency: current_user.currency,
          source: :user
      }
    end

    if session[:current_currency]
      return {
          currency: session[:current_currency],
          source: :session
      }
    end

    return {
        currency: 'RUB',
        source: :default
    }
  end

  def set_currency currency
    if current_user
      current_user.currency = currency
      current_user.save!
    else
      session[:current_currency] = currency
    end
  end
  # /currency

  helper_method :abs_url
  def abs_url path
    "http://#{Settings.host}#{path}"
  end

  protected
  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end
  # /Turn on request forgery protection

  def render *args
    run_callbacks :render do
      super
    end
  end

  def before_action_cb
    @wide_header = false

    seo = Settings.seo
    set_meta_tags title: seo.title
    set_meta_tags description: seo.description
    set_meta_tags keywords: seo.keywords
  end

  def apply_meta_tags object
    if object.respond_to? :meta_tags
      object.meta_tags.each do |mt|
        set_meta_tags mt.key => mt.value unless mt.value.nil? || mt.value == ''
      end
    end

    @page_title = object.meta_title if object.respond_to?(:meta_title) && object.meta_title != ''
    @page_description = object.meta_description if object.respond_to?(:meta_description) && object.meta_description != ''

    set_meta_tags :og => {
        title: object.respond_to?(:meta_title) && object.meta_title != '' ? object.meta_title : @page_title,
        image: object.respond_to?(:og_image) && object.og_image != '' ? abs_url(object.og_image) : '',
        description: object.respond_to?(:og_description) && object.og_description != '' ? object.og_description : @page_description,
        url: abs_url(object.respond_to?(:slug) ? object.slug : '')
    }
  end

  def use_meta_page
    if request.fullpath != '/'
      path = request.fullpath.gsub('/', '')
      @meta_page = MetaPage.find_by(path: path)
      apply_meta_tags @meta_page if @meta_page
    end

    set_meta_tags :title => "#{meta_tags[:title]} - #{params[:page]}" if params[:page]
  end

  def referer
    request.headers['referer']
  end

  #recipe
  def recipe_json recipe
    user_id = current_user ? current_user.id : nil
    Food.current_user_id = user_id

    recipe.to_json(
        include:
            {
                :recipe_text_nodes => {
                    include: [:image],
                    methods: [:image_cache]
                },
                :components => {
                    :include => {
                        :food => {
                            only: [:id, :name],
                            food_weights: { only: [:kg, :count_type] },
                            food_value: { only: [:energy, :protein, :fat, :sugar] },
                            methods: [:prices]
                        }
                    }
                },
            },
        methods: [:image_cache]
    )
  end
end
