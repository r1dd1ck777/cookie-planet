(function ($) {
    var localStorage = window.localStorage;
    $.support.localStorage = localStorage ? true : false;

    $.ls = {
        get: function(key){
            if (localStorage){
                var parsed = $.parseJSON(localStorage.getItem(key));
                if (parsed == null){return null;}

                var date = new Date();
                if (parsed.expires_at == 'null' || parsed.expires_at >= date.getTime()){
                    return parsed.value;
                }
            }

            return null;
        },
        set: function(key, value, expires_in){
            expires_in = expires_in || null;
            if (localStorage){
                var date = new Date();
                var parsed = {
                    expires_at: expires_in ? (date.getTime() + (expires_in * 1000)) : 'null',
                    value: value
                };
                localStorage.setItem(key, JSON.stringify(parsed));
            }
            return;
        },
        clear: function(key){
            if (localStorage) localStorage.removeItem(key);
            return;
        },
        flushAll: function(){
            if (localStorage) localStorage.clear();
            return;
        },
        exists: function(key){
            if (localStorage){
                var parsed = $.parseJSON(localStorage.getItem(key));
                if (parsed == null){
                    return false;
                }

                var date = new Date();
                if (parsed.expires_at != 'null' && parsed.expires_at < date.getTime()){
                    return false;
                }

                return true;
            }else{
                return false;
            }
        },
        fetch: function(key, expires_in, callback){
            var value = this.get(key);
            if (value == null){
                var newValue = callback();
                this.set(key, newValue, expires_in);
            }

            return value ? value : newValue;
        }
    }

})(jQuery);
