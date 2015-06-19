'use strict';

angular.module('v-recipe-core', ['rid-settings', 'ui.select2', 'rid-ls', 'rid-ls', 'rid-i18n', 'rid-contenteditable', 'rid-http', 'rid-image-file'])
    .run(['$ridSettings', '$vRecipeFoodPrototype', '$vRecipeComponentPrototype', '$vRecipeComponentClass', '$vRecipeRecipePrototype', '$vRecipeTextNodeClass', '$vRecipeTextNodePrototype', '$vRecipeCountTypeClass',
        function($ridSettings, $vRecipeFoodPrototype, $vRecipeComponentPrototype, $vRecipeComponentClass, $vRecipeRecipePrototype, $vRecipeTextNodeClass, $vRecipeTextNodePrototype, $vRecipeCountTypeClass){
            $ridSettings.foods = $ridSettings.foods || [];

            var recipeFoods = _.map($ridSettings.recipe.components, function(component){
                return component.food;
            });

            console.log(_.find($ridSettings.foods, function(v){return v.id == 777;}));

            _.each(recipeFoods, function(recipeFood){
                if (!recipeFood.is_moderated){
                    recipeFood.food_weights = $vRecipeCountTypeClass.initAllPosible();
                    $ridSettings.foods.push(recipeFood);
                }
            });

            _.each($ridSettings.foods, function(food){
                _.extend(food, $vRecipeFoodPrototype);
            });

            _.each($ridSettings.recipe.components, function(component){
                _.extend(component, $vRecipeComponentPrototype);
                component.count = parseFloat(component.count);
            });

            _.each($ridSettings.recipe.recipe_text_nodes, function(recipe_text_node){
                _.extend(recipe_text_node, $vRecipeTextNodePrototype);
                recipe_text_node._has_image = true;
            });

            _.extend($ridSettings.recipe, $vRecipeRecipePrototype);

            if ($ridSettings.recipe.components.length <= 0){
                $ridSettings.recipe.components.push($vRecipeComponentClass.init());
            }
            if ($ridSettings.recipe.recipe_text_nodes && $ridSettings.recipe.recipe_text_nodes.length <= 0){
                $ridSettings.recipe.recipe_text_nodes.push($vRecipeTextNodeClass.init());
            }
        }])
    .factory('$vRecipeTextNodePrototype', ['$vRecipeCurrency', function($vRecipeCurrency){
        return {
            get_image: function(){
                var self = this;

                if (!angular.isDefined(self.image)){
                    return null;
                }

                return self.image._base64 ? self.image._base64 : self.image.url;
            },
            has_image: function(){
                var self = this;

                return self._has_image;
            },
            set_image: function(src){
                var self = this;

                self._has_image = true;
                angular.isDefined(self.image) ? self.image._base64 = src : self.image = {_base64: src};
                self._dom_image.attr('src', src);
            }
        }
    }])
    .directive('applyTooltip', [function(){
        return {
            link: function(scope, element, attrs){
                element.tooltip();
            }
        };
    }])
    .factory('$vRecipeFoodPrototype', ['$vRecipeCurrency', function($vRecipeCurrency){
        return {
            currency: $vRecipeCurrency,
            db_price: function(){
                var self = this;
                var result = null;

                for (var key in self.prices){
                    var price = self.prices[key];

                    if (result == null){
                        result = price;
                    }

                    if (price.user_id != null && price.currency == self.currency.currency){
                        result = price;
                        break;
                    }

                    if (price.currency == self.currency.currency){
                        result = price;
                        continue;
                    }
                }

                return result;
            },
            price: function(){
                var self = this;
                var result = self.db_price();
                if (result == null) {return null;}
                if (result.currency != self.currency.currency){
                    var transfer_rate = self.currency.rates[self.currency.currency] / self.currency.rates[result.currency];
                    result = {
                        price: result.price * transfer_rate,
                        count_type: result.count_type,
                        translated: true
                    };
                }

                return result;
            },
            cost_of: function(count_type){
                var self = this;
                var price = self.price();
                if (price == null){return 0;}

                var coof = self.trans_weight(price.count_type, count_type);

                return self.price().price * coof;
            },
            food_value_of: function(count_type, params){
                // TODO -o
                var self = this;
                var coof = self.trans_weight('kg', count_type) * 10;

                return angular.isDefined(self.food_value) ? self.food_value[params] * coof : 0;
            },
            _find_food_weight: function(count_type){
                var self = this;

                // TODO -o
                var r = _.find(self.food_weights, function(v){
                    return v.count_type == count_type;
                })

                return r;
            },
            trans_weight_to_kg_from: function(count_type){
                var self = this;
                count_type = angular.isObject(count_type) ? count_type.id : count_type;

                switch (count_type){
                    case 'kg':
                        return 1;
                        break;
                    case 'gr':
                        return 0.001;
                        break;
                    default:
                        var food_weight = self._find_food_weight(count_type);
                        return food_weight ? food_weight.kg : 0;
                }
            },
            trans_weight_from_kg_to: function(count_type){
                var self = this;

                count_type = angular.isObject(count_type) ? count_type.id : count_type;

                switch (count_type){
                    case 'kg':
                        return 1;
                        break;
                    case 'gr':
                        return 1000;
                        break;
                    default:
                        var food_weight = self._find_food_weight(count_type);
                        return food_weight ? Math.round_to(1/food_weight.kg, 2) : 0;
                }
            },
            trans_weight: function(from_count_type, to_count_type){

                var self = this;
                if (from_count_type == to_count_type){
                    return 1
                }
                if (from_count_type == 'ml' && to_count_type == 'l'){
                    return 1000
                }
                if (from_count_type == 'l' && to_count_type == 'ml'){
                    return 0.001
                }
                var in_kg = self.trans_weight_to_kg_from(to_count_type)
                return (in_kg * self.trans_weight_from_kg_to(from_count_type))
            }
        };
    }])
    .factory('$vRecipeCountTypeClass', ['$ridSettings', function($ridSettings){
        return {
            initAllPosible: function(){
                return _.map($ridSettings.countTypes, function(v){
                    var kg = 0;
                    switch (v.id){
                        case 'kg':
                            kg = 1;
                            break;
                        case 'gr':
                            kg = 0.001;
                            break;
                        case 'l':
                            kg = 1;
                            break;
                        case 'ml':
                            kg = 0.001;
                            break;
                    }

                    var count_type = {
                        count_type: v.id,
                        kg: kg
                    };

                    return count_type;
                });
            }
        }
    }])
    .factory('$vRecipeComponentPrototype', ['$ridSettings', '$vRecipeFoodPrototype', '$vRecipeCountTypeClass',
        function($ridSettings, $vRecipeFoodPrototype, $vRecipeCountTypeClass){
        var prototype = {
            food_value: function(param){
                var self = this;

                // TODO -o
                return Math.round_to(self.food().food_value_of(self.count_type, param) * self.count, 2);
            },
            food_value_in_100: function(param){
                var self = this;
                var food_value = self.food_value(param);

                // TODO -o
                return Math.round_to(food_value * (self.weight() / 10), 2);
            },
            food: function(){
                var self = this;
                var result = _.find($ridSettings.foods, function(v){
                    return v.id == self.food_id;
                });

                // TODO -o
                return angular.isDefined(result) ? result : initBasicFood(self.food_id);
            },
            cost: function(){
                var self = this;

                return Math.round_to(self.food().cost_of(self.count_type) * self.count, 2);
            },
            weight: function(){
                var self = this;

                return Math.round_to(self.food().trans_weight_to_kg_from(self.count_type) * self.count, 3);
            }
        };

        function initBasicFood(name){
            var food = {
                name: name,
                food_weights: $vRecipeCountTypeClass.initAllPosible()
            };

            return _.extend(food, $vRecipeFoodPrototype);
        }

        return prototype;
    }])
    .factory('$vRecipeRecipePrototype', [function(){
        return {
            food_value_in_100: function(param){
                var self = this;
                var food_value = self.food_value(param);

                // TODO -o
                return Math.round_to(food_value / self.weight() / 10, 2);
            },
            food_value: function(param){
                var self = this;

                return _.reduce(self.components, function(memo, component){
                    return memo + component.food_value(param);
                }, 0);
            },
            cost: function(){
                var self = this;

                return _.reduce(self.components, function(memo, component){ return memo + component.cost(); }, 0);
            },
            weight: function(){
                var self = this;

                return Math.round_to(_.reduce(self.components, function(memo, component){ return memo + component.weight(); }, 0), 3);
            },
            show_image_placeholder: function(){
                var self = this;

                if (self.id == null && self.image_cache == undefined && self.image._base64 == undefined){
                    return true;
                }

                return false;
            },
            get_image: function(){
                var self = this;

                return self.image._base64 ? self.image._base64 : self.image.list.url
            }
        };
    }])
    .factory('$vRecipeComponentClass', ['$ridSettings', '$vRecipeComponentPrototype',
        function($ridSettings, $vRecipeComponentPrototype){
            return {
                init: function(){
                    var newComponent  = {
                        food_id: $ridSettings.foods[0].id,
                        count_type: $ridSettings.foods[0].food_weights[0].count_type,
                        count: 1
                    };
                    _.extend(newComponent, $vRecipeComponentPrototype);

                    return newComponent;
                }
            };
        }])
    .factory('$vRecipeTextNodeClass', ['$ridSettings', '$vRecipeTextNodePrototype',
        function($ridSettings, $vRecipeTextNodePrototype){
            return {
                init: function(defaults){
                    var newNode  = {
                        text: '',
                        _imageSrc: '',
                        node: ''
                    };
                    if (angular.isDefined(defaults)){
                        newNode = _.extend(newNode, defaults);
                    }
                    _.extend(newNode, $vRecipeTextNodePrototype);

                    return newNode;
                }
            };
        }])
    .factory('$vRecipeCurrency', ['$ridSettings', function($ridSettings){
        return {
            currency: $ridSettings.currency_data.currency,
            source: $ridSettings.currency_data.source,
            isDefault: ($ridSettings.currency_data.source == 'default'),
            labels:{
                RUB: 'руб',
                UAH: 'грн',
                BYR: 'руб'
            },
            label: function(){
                var self = this;

                return self.labels[self.currency]
            },
            rates: {
                RUB: 58,
                UAH: 26,
                BYR: 14750
            }
        };
    }])
    .directive('vRecipeCurrency', ['$vRecipeCurrency', '$compile', function($vRecipeCurrency, $compile){
        return {
            scope: {
                vRecipeCurrency: '@'
            },
            controller: ['$scope', '$http', '$rootScope', function($scope, $http, $rootScope){
                $scope.saveCurrency = function(currency){
                    $vRecipeCurrency.currency = currency;
                    $vRecipeCurrency.isDefault = false;
                    // not nice(
                    angular.element('[v-recipe-currency]').popover('hide');

                    $http.post('/ajax/profile/currency', {
                        currency: currency
                    }).then(function(){
                        $rootScope.$broadcast('save-currency.success');
                    });
                };
            }],
            compile: function compile( tElement, tAttributes ) {
                return {
                    pre: function preLink( scope, element, attributes ) {
                        var compiledDialog = $compile(angular.element(scope.vRecipeCurrency).html())(scope);
                        element.popover({
                            placement: 'auto',
                            html: true,
                            content: compiledDialog
                        });
                    },
                    post: function postLink( scope, element, attributes ) {
                        if (!$vRecipeCurrency.isDefault){return;}

                        setTimeout(function(){
                            angular.element('[v-recipe-currency]:first').popover('show');
                        }, 1000);
                    }
                };
            }
        };
    }])
    .controller('vMainCore', ['$scope', '$vRecipeCurrency', function($scope, $vRecipeCurrency){
        $scope.currencyLabel = function(){
            return $vRecipeCurrency.label();
        };

        $scope.isEmptyHtml = function(html){
            var tmp = document.createElement("DIV");
            tmp.innerHTML = html;
            var result = (tmp.textContent || tmp.innerText || "").trim();

            return result == '';
        };
    }])
;