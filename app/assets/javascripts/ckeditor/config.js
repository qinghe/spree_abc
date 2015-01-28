CKEDITOR.editorConfig = function( config ) {
    config.language = 'zh-cn';   
    // Default setting.
    //config.toolbarGroups = [
    //    { name: 'document',    groups: [ 'mode', 'document' ] },
    //    { name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
    //    //{ name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
    //    //{ name: 'forms' },
    //    //'/',
    //    //{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
    //    //{ name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ] },
    //    { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ] },
    //    { name: 'links' },
    //    { name: 'insert' },{ name: 'tools' },
    //    '/',
    //    { name: 'styles' },
    //    { name: 'colors' },
    //    { name: 'others' },        
    //    //{ name: 'about' }
    //];

    config.toolbar = 'Full';   
    config.toolbar_Full = [ 
      { name: 'document', items : [ 'Source','-','NewPage','DocProps','Preview','Templates' ] },
      { name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] }, 
      //{ name: 'editing', items : [ 'Find','Replace','-','SelectAll','-','SpellChecker', 'Scayt' ] },
      //{ name: 'forms', items : [ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton','HiddenField' ] },
      //'/',
      //{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
      //{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv', '-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
      { name: 'links', items : [ 'Link','Unlink','Anchor' ] },     
      //{ name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak','Iframe' ] },
      { name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule','SpecialChar' ] },
      { name: 'tools', items : [ 'Maximize', 'ShowBlocks' ] },
      '/', 
      { name: 'styles', items : [ 'Styles','Format','Font','FontSize' ] },     
      { name: 'colors', items : [ 'TextColor','BGColor' ] }, 
      //{ name: 'tools', items : [ 'Maximize', 'ShowBlocks','-','About' ] } 

    ];


};
