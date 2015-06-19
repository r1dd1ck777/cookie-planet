//= require jquery/jquery
//= require active_admin/base
//= require select2
//= require select2/select2_locale_ru

(function($){
    $(document).ready(function(){
        $('select[multiple]').select2();
    });
})(jQuery);
