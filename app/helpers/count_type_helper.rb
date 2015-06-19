module CountTypeHelper

  def t_count_type ct
    t('count_type.' + ct)
  end

  def self.select_options(type)
    self.to_select_options self.send(type.to_s + '_types')
  end

  def self.to_array_of_objects(type)
    self.send(type.to_s + '_types').map{|k, v| { id: k, title: v[:title] } }
  end

  protected

  def self.types
    {
        :kg => {
            :title => 'кг.'
        },
        :gr => {
            :title => 'гр.'
        },
        :item => {
            :title => 'шт.'
        },
        :glass => {
            :title => 'ст.'
        },
        :s_spoon => {
            :title => 'ч.л.'
        },
        :l_spoon => {
            :title => 'ст.л.'
        },
        :sand => {
            :title => 'щеп.'
        },
        :box => {
            :title => 'пачка'
        },
        :l => {
            :title => 'л.'
        },
        :ml => {
            :title => 'мл.'
        }
    }
  end

  def self.to_select_options hash
    Hash[hash.map{|k, v| [ v[:title], k ]}]
  end

  def self.weight_types
    self.types.select{ |key,_| ![:kg, :gr].include?(key) }
  end

  def self.price_types
    self.types
  end
end
