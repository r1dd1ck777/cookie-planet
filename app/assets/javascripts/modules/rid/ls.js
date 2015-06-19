'use strict';

(function(){
    angular.module('rid-ls', ['LocalStorageModule'])
        .factory('$ridLs', ['localStorageService', function(localStorageService){
            return {
                get: function(k){
                    var v = localStorageService.get(k);
                    if (v == 'false') return false;
                    if (v == 'true') return true;
                    return v;
                },
                set: function(k, v){
                    localStorageService.set(k,v);
                }
            }
        }])
    ;
})();