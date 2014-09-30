CKEDITOR.editorConfig = (config) ->
  config.language = "zh"
  config.uiColor = "#AADC6E"



  config.toolbarGroups = [
      { name: 'document',    groups: [ 'mode', 'document', 'doctools' ] },
      { name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
      { name: 'forms' },
      { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
      { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ] },
      { name: 'links' },
      { name: 'insert' },
      { name: 'styles' },
      { name: 'colors' },
      { name: 'tools' },
      { name: 'others' },
      { name: 'about' }
  ]


  true