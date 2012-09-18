require.config
  shim:
    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'
    underscore:
      exports: '_'
    handlebars:
      exports: 'Handlebars'
    bootstrap:
      deps: ['jquery']
    leaflet:
      exports: 'L'
  paths:
    bootstrap: 'lib/bootstrap'
    jquery: 'lib/jquery-1.7.2'
    underscore: 'lib/underscore'
    handlebars: 'lib/handlebars-1.0.0.beta.6'
    backbone: 'lib/backbone'
    timepicker: 'lib/jquery.timePicker'
    leaflet: 'lib/leaflet-src'
    async: 'lib/async'
    hbs: 'lib/hbs'
    template: '../template'
  hbs:
    disableI18n: true
  pragmasOnSave:
    excludeHbsParser : true,
    excludeHbs: true,
    excludeAfterBuild: true

window.Reitti ?= {}

require ['jquery', 'underscore', 'backbone', 'router', 'bootstrap'], ($, _, Backbone, Router) ->

  class Reitti.Event extends Backbone.Events
  Reitti.Router = new Router()
  Backbone.history.start()
    
  $ ->
    if navigator.geolocation
      navigator.geolocation.watchPosition(
        (position) -> Reitti.Event.trigger 'position:change', position,
        () ->,
        { enableHighAccuracy: true})
