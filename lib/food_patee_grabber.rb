require "net/http"

class FoodPateeGrabber < BaseGrabber
  @hold_url = nil

  def unhold_from url
    @hold_url = url
  end

  def sleep_delay
    sleep(rand)
  end

  def process_all
    letters = "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЭЮЯ".split('')

    letters.each do |l|
      page = get_page("http://www.patee.ru/cookingpedia/foods/?l=#{l}")
      process_letter page
    end
  end

  def process_letter page
    if page.nil?
      puts "process_letter ERROR"
      return nil
    end

    food_links = page.css('.sel5 a').map{|i| i.attr('href')}.uniq

    food_links.each do |food_link|
      food_url = url(food_link)
      if @hold_url == food_url
        @hold_url = nil
        p "unhold #{food_url}"
      end

      if @hold_url == nil
        process_food get_page(food_url)
      else
        p "skip #{food_url}"
      end

    end
  end

  def process_food page
    if page.nil?
      puts "process_food ERROR"
      return nil
    end

    category = FoodCategory.find_or_initialize_by name: fix_text(page.at_css('.i2cur').text)

    food = Food.find_or_initialize_by name: fix_text(page.at_css('.article h1').text)
    food.food_category = category

    img_tag = page.at_css('.img.i390x img')
    if img_tag
      image_url = img_tag.attr('src')
      food.remote_image_url = image_url
    end

    food.food_value.destroy! if food.persisted? && food.food_value
    food_value = FoodValue.new
    food_value.protein = get_food_value page, 'Белки'
    food_value.fat = get_food_value page, 'Жиры'
    food_value.sugar = get_food_value page, 'Углеводы'
    food_value.energy = get_food_energy page
    food.food_value = food_value

    return food.save!, food
  end

  def fix_text text, is_float = false
    text.gsub("\n", '').gsub("\t", '').gsub("#{ is_float ? "," : "nannanana"}", '.').strip
  end

  def remote_base_url
    "http://www.patee.ru"
  end

  def get_food_value page, name
    tag = page.at_css('.article')
    unless tag
      return 0
    end
    matches = tag.text.match(/#{name} ([0-9,]+)%/)
    matches[1].gsub(',', '.') if matches
  end

  def get_food_energy page
    tag = page.at_css('.article')
    unless tag
      return 0
    end
    matches = tag.text.match(/([0-9,]+) (килокалории|килокалорий|килокалория)/)
    matches[1].gsub(',', '.') if matches
  end
end