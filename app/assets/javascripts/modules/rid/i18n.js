'use strict';

(function(){
    angular.module('rid-i18n', [])
        .factory('$ridI18n', [function(){
            return {
                db: {
                    'ru.count_type.item' : 'шт.',
                    'ru.count_type.kg' : 'кг.',
                    'ru.count_type.gr' : 'гр.',
                    'ru.count_type.glass' : 'стакан',
                    'ru.count_type.s_spoon' : 'ч.л',
                    'ru.count_type.l_spoon' : 'ст.л',
                    'ru.count_type.sand' : 'щеп.',
                    'ru.count_type.box' : 'пачка',
                    'ru.count_type.l' : 'л.',
                    'ru.count_type.ml' : 'мл.'
                },
                add: function(key, value){
                    this.db[key] = value;
                },
                _: function(key){
                    return this.db[key];
                }
            };
        }])
    ;
})();