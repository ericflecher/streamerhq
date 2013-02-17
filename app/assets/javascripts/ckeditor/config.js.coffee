CKEDITOR.editorConfig = (config) ->
  config.toolbarGroups = [
    {
      name: 'basicstyles'
      groups: [ 'basicstyles' ] #, 'cleanup' ]
    }
    { name: 'undo' }
    { name: 'links' }
    # { name: 'spellchecker' }
    { name: 'tools' }
    { name: 'mode' }
    '/'
    { name: 'styles' }
    { name: 'colors' }
    # { 
    #   name: 'clipboard'
    #   groups: [ 'clipboard' , 'undo' ]
    # }
    # { name: 'others' }
    # {
    #   name: 'editing'
    #   groups: [ 'find', 'selection', 'spellchecker' ]
    # }
    # { name: 'insert' }
    # { name: 'forms' }
    # { 
    #   name: 'document'
    #   groups: [ 'mode' , 'document', 'doctools' ]
    # }
    # '/'
    # {
    #   name: 'paragraph'
    #   groups: [ 'list', 'indent', 'blocks', 'align' ]
    # }
    # { name: 'about' }
  ]
  true