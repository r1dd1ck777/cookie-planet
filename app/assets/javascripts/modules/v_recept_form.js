'use strict';

angular.module('v-recipe-form', ['v-recipe-core'])
    .run(['$ridSettings', '$vRecipeTextNodeClass', function($ridSettings, $vRecipeTextNodeClass){
        _.each($ridSettings.recipe.recipe_text_nodes, function(node){
//            node._uploaded = true;
        });

        ga('send', 'event', 'RecipeFormSubmission', $ridSettings.recipe.id != null ? 'newForm' : 'editForm');
    }])
    .directive('recipeTextNode', ['$timeout', function($timeout){
        return {
            scope: {
                recipeTextNode: '='
            },
            link: function(scope, element, attrs){
                $timeout(function(){
                    if (scope.recipeTextNode._trigger_click){
                        var input = element.find('.file');
                        input.trigger('click');
                    }
                }, 100);
            }
        };
    }])
    .directive('recipeTextNodeImage', [function(){
        return {
            scope: {
                textNode: '=recipeTextNodeImage'
            },
            link: function(scope, element, attrs){
                scope.textNode._dom_image = element;
                element.attr('src', scope.textNode.get_image());
            }
        };
    }])
    .directive('vRecipeSelect2New', ['$ridSettings', function($ridSettings){
        return {
            require: 'ngModel',
            link: function(scope, element, attrs, ngModel){
                element.select2({
                    minimumInputLength: 3,
                    createSearchChoice: function(term, data) {
                        if (jQuery(data).filter(function() { return this.text.localeCompare(term)===0; }).length===0)
                        {
                            return {id:term, text:term};
                        }
                    },
                    multiple: false,
                    data: _.map($ridSettings.foods, function(v){
                        return { id: v.id, text: v.name }
                    })
                });

                ngModel.$render = function() {
                    // TODO -o
                    element.select2("data", { id: ngModel.$modelValue, text: _.find($ridSettings.foods, function(v){
                        return v.id == ngModel.$modelValue;
                    }).name });
                };
            }
        }
    }])
    .directive('vRecipeSelect2CountType', ['$ridI18n', '$vRecipeCountTypeClass', function($ridI18n, $vRecipeCountTypeClass){
        return {
            require: 'ngModel',
            scope: {
                component: '='
            },
            link: function(scope, element, attrs, ngModel){
                var data;

                element.select2({
                    multiple: false,
                    data: dataOfComponent(scope.component)
                });

                scope.$watch('component.food_id', function(){
                    var count_type = getCountType(scope.component.count_type, scope.component);
                    element.select2({
                        data: dataOfComponent(scope.component),
                        initSelection: function(element, callback){
                            callback({
                                id: count_type.count_type,
                                text: $ridI18n._('ru.count_type.' + count_type.count_type)
                            });
                        }
                    });
                    scope.component.count_type = count_type.count_type;

                    function getCountType(count_type_id, component){
                        var component_food_weights = component.food().food_weights;
                        var existed = _.find(component_food_weights, function(v){
                            return v.count_type == count_type_id;
                        });

                        return !!existed ? existed : component_food_weights[0];
                    }
                });

                ngModel.$render = function() {

                    // TODO -t
                    var text = 'ru.count_type.' + _.find(data, function(v){
                        return v.id == ngModel.$modelValue || v.count_type == ngModel.$modelValue;
                    }).id;

                    // TODO -o
                    element.select2("data", { id: ngModel.$modelValue, text: $ridI18n._(text) });
                };

                function dataOfComponent(component){
                    console.log(component.food());
                    data = _.map(component.food().food_weights, function(v){
                        return { id: v.count_type, text: $ridI18n._('ru.count_type.' + v.count_type) }
                    });

                    return data;
                }
            }
        }
    }])
    .controller('vMain', ['$scope', '$ridSettings', '$vRecipeComponentClass', '$ridLs', '$vRecipeTextNodeClass', '$http', '$timeout',
        function($scope, $ridSettings, $vRecipeComponentClass, $ridLs, $vRecipeTextNodeClass, $http, $timeout){

            $scope.ping = function(){
                alert('pong');
            };
            $scope.component_views = ['none', 'component', 'recipe'];
            $scope._tmp = {};
            $scope._tmp.component_view = $ridLs.get('recipe_form_component_view') ? $ridLs.get('recipe_form_component_view') : 0;

            $scope.recipe = $ridSettings.recipe;

            $scope.addComponent = function(){
                ga('send', 'event', 'RecipeForm', 'addComponent');
                var newComponent = $vRecipeComponentClass.init();
                $scope.recipe.components.push(newComponent);
//                $rootScope.$broadcast('add-component', newComponent);
            };

            $scope.removeComponent = function(component){
                ga('send', 'event', 'RecipeForm', 'removeComponent');
                component.count = 0;
                if (component.id != undefined){
                    component._destroy = true;
                }else{
                    $scope.recipe.components = _.without($scope.recipe.components, component);
                }
            };

            $scope.removeTextNode = function(text_node){
                ga('send', 'event', 'RecipeForm', 'removeTextNode');
                if (text_node.id != undefined){
                    text_node._destroy = true;
                }else{
                    $scope.recipe.recipe_text_nodes = _.without($scope.recipe.recipe_text_nodes, text_node);
                }
            };

            $scope.newComponentView = function(){
                var new_value = $scope._tmp.component_view >=  $scope.component_views.length-1 ? 0 : $scope._tmp.component_view+1;
                $scope._tmp.component_view = new_value;
                $ridLs.set('recipe_form_component_view', new_value);
                ga('send', 'event', 'RecipeFormComponentView', 'change', new_value);
            };

            $scope.addImageNode = function(){
                ga('send', 'event', 'RecipeForm', 'addImageNode');
                var text_node = $vRecipeTextNodeClass.init({
                    node: 'image',
                    _trigger_click: true
                });

                $scope.recipe.recipe_text_nodes.push(text_node);
            };
            $scope.addTextNode = function(){
                ga('send', 'event', 'RecipeForm', 'addTextNode');
                var text_node = $vRecipeTextNodeClass.init();

                $scope.recipe.recipe_text_nodes.push(text_node);
            };

            $scope.isSubmited = false;
            var formEl = angular.element('.v-recipe-form-el');
            formEl.on('submit', submit);
            var isFirstSubmission = true;

            function submit(e){
                if (isFirstSubmission){
                    isFirstSubmission = false;
                    var event = ($ridSettings.recipe.id != null ? 'edit' : 'new') + 'Form';
                    ga('send', 'event', 'RecipeFormSubmission', event);
                    event = event + (isSubmitionReady() ? '-ImgReady' : '-ImgLoading');
                    ga('send', 'event', 'RecipeFormSubmission', event);
                }

                $scope.$apply(function(){
                    $scope.isSubmited = true;
                });

                if (isSubmitionReady()){
                    formEl.off('submit', submit);
                    formEl.submit();
                }else{
                    $timeout(function(){
                        formEl.submit();
                    }, 1000);
                }

                e.preventDefault();
                return false;
            }

            $scope.onImagePick = function(scope, filename, base64src, file, fileInput){
                var text_node = scope.imageObject;
                text_node._trigger_click = false;
                text_node._need_upload = true;
                text_node.set_image(base64src);

                // Get our file
                var file = dataURLtoBlob(base64src);

                // Create new form data
                var fd = new FormData();

                // Append our Canvas image file to the form data
                fd.append("image", file, 'blob.'+extOf(base64src));

                // And send it
                $http.post("/ajax/recipe/text_nodes", fd, {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                }).then(function(response){
                    text_node.image_cache = response.data.cache;
                    text_node._need_upload = false;
                    resetFormElement(fileInput);
                });

                function resetFormElement(e) {
                    e.wrap('<form>').closest('form').get(0).reset();
                    e.unwrap();
                }

                function dataURLtoBlob(dataURL) {
                    // Decode the dataURL
                    var data = dataURL.split(',');
                    var info = data[0];
                    var code = data[1];
                    var binary = atob(code);
                    // Create 8-bit unsigned array
                    var array = [];
                    for(var i = 0; i < binary.length; i++) {
                        array.push(binary.charCodeAt(i));
                    }
                    // Return our Blob object
                    return new Blob([new Uint8Array(array)], {type: typeOf(info)});
                }
                function typeOf(info){
                    return info.match(/data:([\w\/]+);base64/i)[1];
                }

                function extOf(info){
                    return info.match(/\/([\w]+);base64/i)[1];
                }
            };

            $scope.isSubmitionReady = isSubmitionReady;

            function isSubmitionReady(){
                return !_.find($scope.recipe.recipe_text_nodes, function(v){
                    return v._need_upload;
                });
            };
        }])
;