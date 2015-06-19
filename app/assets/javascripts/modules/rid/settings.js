'use strict';

(function(){
    angular.module('rid-settings', [])
        .factory('$ridSettings', function(){
            var settings = {};
            angular.element('[rid-settings]').each(function(){
                var $el = angular.element(this);
                var key = $el.attr('rid-settings');
                settings[key] = angular.element.parseJSON($el.html());
            });

            return settings;
        })
        .directive('ridSelect2', [function(){
            return {
                link: function(scope, element, attrs){
                    element.select2({});
                }
            }
        }])
    ;
})();