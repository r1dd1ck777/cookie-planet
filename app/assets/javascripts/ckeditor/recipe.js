if(typeof(CKEDITOR) != 'undefined')
{
    CKEDITOR.editorConfig = function( config )
    {
        config.toolbar = 'Easy';
        config.toolbar_Easy = [
            { name: 'basicstyles', items: [ 'Bold', 'Italic' ] },
            { name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
            { name: 'styles', items: [ 'Styles', 'Format', 'Font', 'FontSize' ] },
            { name: 'insert', items: [ 'Table', 'Smiley', 'SpecialChar'] }
        ]
    };
} else{
    console.log("ckeditor not loaded")
}