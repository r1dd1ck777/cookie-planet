'use strict';

//handling errors
(function(){
    angular.module('rid-http', [])
        .config(['$provide', '$httpProvider', function($provide, $httpProvider) {
            $provide.factory('httpInterceptor', ['$q', '$rootScope', function ($q, $rootScope) {
                return {
                    'response': function(response) {
                        console.log('success http');
                        return response || $q.when(response);
                    },

                    'responseError': function(rejection) {
                        $rootScope.$broadcast('http-error', rejection);
                        console.log('error http');
//                    if (canRecover(rejection)) {
//                        return responseOrNewPromise;
//                    }
                        return $q.reject(rejection);
                    }
                };
            }]);
            $httpProvider.interceptors.push('httpInterceptor');
        }])
    ;
})();