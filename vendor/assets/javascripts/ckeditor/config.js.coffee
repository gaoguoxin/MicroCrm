CKEDITOR.editorConfig = (config) ->
  config.language = "zh"
  config.uiColor = "#489ac1"
  config.toolbarGroups = [
      { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
      { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ] },
      { name: 'styles' },
      { name: 'colors' },
      { name: 'tools' },
      { name: 'others' }
  ]
  true