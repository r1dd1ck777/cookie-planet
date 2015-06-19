//= require recept

'use strict';

//top loader bar
(function($){
    var onReady = function(){
        var loaderTop = $('.loader-top-bar');
        loaderTop.removeClass('in-action');
    };

    $(document).ready(onReady);
    $(document).on('page:load', onReady);
    $(document).on('page:before-change', function(){
//        console.log('page:before-change');
        var loaderTop = $('.loader-top-bar');
        loaderTop.addClass('in-action');
    });
    $(document).on('page:before-unload', function(){
//        console.log('page:before-unload');
        var loaderTop = $('.loader-top-bar');
        loaderTop.removeClass('in-action');
    });
})(jQuery);

// popover
(function($){
    var onReady = function(){
        $('[apply-tooltip]').tooltip();
    };

    $(document).ready(onReady);
    $(document).on('page:load', onReady);
})(jQuery);

// recipe show navigation
(function($){
    var onReady = function(){
        var keys = $("[apply-click-on-key-up]");
        if (keys.length){
            $(document).on('keyup', function(e){
                var selector = '[apply-click-on-key-up="'+e.keyCode+'"]';
                var link = $(selector);
                if (link.length){
                    $(document).trigger('page:before-change');
                    Turbolinks.visit( $(selector).attr("href") );
                }
            });
        }
    };

    $(document).ready(onReady);
    $(document).on('page:load', onReady);
})(jQuery);


// fix height
(function($){
    var onReady = function(){
        // window in general
        if ($(window).height() > $('body').height()){
            $('body').height($(window).height());
        }


        // main-content
        var content = $(".main-content");
        var firstContantHeight = content.height();
        var diff = ($('.main-content-wrapper').height() - content.height()) + $('header').height() + 17 + 105;

        if (content.length){
            $(window).on('resize', _.throttle(doResize, 1000));
            doResize();
        }

        function doResize(){
            var windowHeight = $(window).height();
            var newContainerHeight = windowHeight - diff;
            if (firstContantHeight < newContainerHeight){
                content.height(newContainerHeight);
            }
        }
    };

    $(document).ready(onReady);
    $(document).on('page:load', onReady);
})(jQuery);


// angular loader and bootstrap
(function($){
    var onReady = function(){
        var meta = $('[angular-load]');
        var body = $('body');

        body.removeClass('angular-ready');

        if (meta.length){
            var json_loders = $('[angular-load-json]');
            var deferreds = [];

            json_loders.each(function(){
                var js_tag = $(this);
                var url = js_tag.attr('angular-load-json');
                var d = $.Deferred();

                if (!$.ls.exists(url)){
                    $.get(url, function(response){
                        js_tag.html(response);
                        d.resolve(response);
                        $.ls.set(url, response, 60);
                    });
                }else{
                    var response = $.ls.get(url);
                    js_tag.html(response);
                    d.resolve(response);
                }

                deferreds.push(d.promise());
            });

            $.when.apply($, deferreds).then(function() {
                angular.bootstrap(body[0], [meta.attr('angular-load')]);
                body.addClass('angular-ready');
            });
        }
    };

    $(document).ready(onReady);
    $(document).on('page:load', onReady);
})(jQuery);

