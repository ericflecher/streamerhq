$(window).load(function() {
  // Limited toolbar
  $(".cklimited").each(function() {
    CKEDITOR.replace($(this).get(0), {
      toolbarGroups: [
        {
          name: 'basicstyles',
          groups: ['basicstyles']
        }, {
          name: 'undo'
        }, {
          name: 'links'
        }, {
          name: 'tools'
        }, {
          name: 'mode'
        }
      ]
    });
  });
  
  // Basic toolbar
  $(".ckbasic").each(function() {
    CKEDITOR.replace($(this).get(0), {
      toolbarGroups: [
        {
          name: 'basicstyles',
          groups: ['basicstyles']
        }, {
          name: 'undo'
        }, {
          name: 'links'
        }, {
          name: 'tools'
        }, {
          name: 'mode'
        }, '/', {
          name: 'styles'
        }, {
          name: 'colors'
        }
      ]
    });
  });
  
  // Standard (Full) toolbar
  $(".ckstandard").each(function() {
    CKEDITOR.replace($(this).get(0), {
      toolbarGroups: [
        { name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
        { name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
        { name: 'links' },
        { name: 'insert' },
        { name: 'forms' },
        { name: 'tools' },
        { name: 'document',    groups: [ 'mode', 'document', 'doctools' ] },
        { name: 'others' },
        '/',
        { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
        { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ] },
        { name: 'styles' },
        { name: 'colors' },
        { name: 'about' }
      ]
    });
  });
});