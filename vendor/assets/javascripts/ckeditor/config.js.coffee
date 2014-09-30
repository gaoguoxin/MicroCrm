CKEDITOR.editorConfig = (config) ->
  config.language = "zh"
  config.uiColor = "#AADC6E"
  config.toolbarGroups = [
      { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
      { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ] },
      { name: 'styles' },
      { name: 'colors' },
      { name: 'tools' },
      { name: 'others' }
  ]
  true