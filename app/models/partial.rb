class Partial < ActiveRecord::Base
  BLOCKS = {
      # :footer_contacts => 'футер: контакты',
      :contacts_address => 'контакты: адрес',
      :landing_content => 'главная: контент',
      :checkout_ty => 'спасибо за покупку',
  }

  class << self
    def _ key
      partial = find_by placement: key
      partial.nil? ? "отсутствует текст #{key}" : partial.text
    end

    def select_options
      Hash[BLOCKS.map{|k, v| [ v, k ]}]
    end

    def title_for key
      BLOCKS[key.to_sym]
    end
  end

end
