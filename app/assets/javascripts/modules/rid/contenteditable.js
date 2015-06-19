'use strict';

(function(){
    angular.module('rid-contenteditable', [])
        .directive('contenteditable', [function() {
            return {
                restrict: 'A', // only activate on element attribute
                require: '?ngModel', // get a hold of NgModelController
                scope: {
                    placeholder: '@'
                },
                link: function ( scope, element, attrs, ngModel ) {
                    var placeholderText = scope.placeholder || 'def placeholder';
                    var isFirstRender = true;

                    element.html(placeholderText);
                    if(!ngModel) return; // do nothing if no ng-model

                    // Specify how UI should be updated
                    ngModel.$render = function() {
                        element.html(ngModel.$viewValue || placeholderText);
                        checkPlaceholder();

                        if (isFirstRender){
                            initCkeditor();
                            isFirstRender = false;
                        }
                    };

                    // Listen for change events to enable binding
                    element.on('blur keyup change', function() {
                        scope.$apply(read);
                    });
                    element.on('click focus', function() {
                        var html = stripHtml(element.html());
                        if (html == placeholderText){
                            element.html('');
                        }
                        checkPlaceholder();
                    });
                    element.on('blur', function() {
                        var html = stripHtml(element.html());
                        if (html == ''){
                            element.html(placeholderText);
                        }
                        checkPlaceholder();
                    });

                    function read() {
                        var html = element.html();
                        if( attrs.stripBr && html == '<br>' ) {
                            html = '';
                        }

                        ngModel.$setViewValue(html);
                    }

                    function checkPlaceholder(){
                        var html = stripHtml(element.html());
                        if (html == placeholderText){
                            element.addClass('has-placeholder');
                        }else{
                            element.removeClass('has-placeholder');
                        }
                    }

                    function stripHtml(html)
                    {
                        var tmp = document.createElement("DIV");
                        tmp.innerHTML = html;
                        var result = (tmp.textContent || tmp.innerText || "").trim();

                        return result;
                    }

                    function initCkeditor(){
                        if (!attrs.inlineCkeditor){ return; }
                        var id = element.attr('id');
                        var myToolBar = [
                            { name: 'basicstyles', items: [ 'Bold', 'Italic' ] },
                            { name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
                            { name: 'styles', items: [ 'Styles', 'Format', 'Font', 'FontSize' ] },
                            { name: 'insert', items: [ 'Table', 'Smiley', 'SpecialChar'] }
                        ];
                        var config = { language: 'ru' };
                        config.toolbar = myToolBar;
                        CKEDITOR.inline(id, config);
                    }
                }
            };
        }
        ]);
})();