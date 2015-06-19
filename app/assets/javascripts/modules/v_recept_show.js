'use strict';

angular.module('v-recipe-show', ['v-recipe-core'])
    .controller('vShow', ['$scope', '$ridSettings', '$ridI18n', '$timeout', function($scope, $ridSettings, $ridI18n, $timeout){
        $scope.recipe = cloneRecipe();
        var basicParams = basicTmp();
        $scope._tmp = basicTmp();
        $scope._is_new = true;

        // TODO -r
        $scope.calcWeight = function(){
            var v = $scope._tmp.weight;
            v = v == '' ? 0 : v.replace(',', '.');

            var coof = v / basicParams.weight;

            if (v <= 0){
                return;
            }
            $scope.recipe = cloneRecipe();

            _.each($scope.recipe.components, function(component){
                component.count = Math.round_to(component.count * coof, 1);
            });

            $scope._tmp = basicTmp({weight: v});
            $scope._is_new = false;

            ga('send', 'event', 'RecipeShow', 'calcWeight');
        };

        $scope.multiplyWeight = function(multipler){
            $scope._tmp.weight = Math.round_to($scope._tmp.weight * multipler, 2) + '';
            $timeout($scope.calcWeight, 10);
            ga('send', 'event', 'RecipeShow', 'multiplyWeight');
        };

        $scope.calcCost = function(){
            ga('send', 'event', 'RecipeShow', 'calcCost');
            var v = $scope._tmp.cost;
            v = v == '' ? 0 : v.replace(',', '.');

            var coof = v / basicParams.cost;

            if (v <= 0){
                return;
            }
            $scope.recipe = cloneRecipe();

            _.each($scope.recipe.components, function(component){
                component.count = Math.round_to(component.count * coof, 1);
            });

            $scope._tmp = basicTmp({cost: v});
            $scope._is_new = false;
        };

        $scope.calcEnergy = function(){
            ga('send', 'event', 'RecipeShow', 'calcEnergy');
            var v = $scope._tmp.food_value_energy;
            v = v == '' ? 0 : v.replace(',', '.');

            var coof = v / basicParams.food_value_energy;

            if (v <= 0){
                return;
            }
            $scope.recipe = cloneRecipe();

            _.each($scope.recipe.components, function(component){
                component.count = Math.round_to(component.count * coof, 1);
            });

            $scope._tmp = basicTmp({food_value_energy: v});
            $scope._is_new = false;
        };

        $scope.restore = function(){
            $scope._is_new = true;
            $scope._tmp = _.extend({}, basicParams);
            $scope.recipe = cloneRecipe();
        }

        $scope.t = function(s){
            return $ridI18n._(s);
        };

        $scope.$on('save-currency.success', function(){
            $scope.recipe = cloneRecipe();
            basicParams = basicTmp();
            $scope._tmp = _.extend({}, basicParams);
        });

        function basicTmp(m){
            return _.extend({
                weight: Math.round_to($scope.recipe.weight(), 2),
                cost: Math.round_to($scope.recipe.cost(), 2),
                food_value_energy: $scope.recipe.food_value('energy')
            }, m);
        }

        function cloneRecipe(){
            var copy = _.extend({}, $ridSettings.recipe);
            copy.components = _.map(copy.components, function(component){
                return _.extend({}, component);
            });

            return copy;
        }

    }]);