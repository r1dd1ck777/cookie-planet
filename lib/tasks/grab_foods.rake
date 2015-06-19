require "net/http"

namespace :grab do
  task :foods, [:hold_url] => :environment do |t, args|


    grabber = FoodPateeGrabber.new
    grabber.unhold_from args.hold_url if args.hold_url
    grabber.process_all
    p "------------Success"
  end

  task :test => :environment do
    grabber = FoodPateeGrabber.new
    page = grabber.get_page 'http://www.patee.ru/cookingpedia/foods/flour/view/?id=48357'
    r, food = grabber.process_food(page)
    p food.food_value
  end
end