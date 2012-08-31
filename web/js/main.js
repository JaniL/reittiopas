"use strict";

require.config({
  shim: {
    backbone: {
      deps: ['underscore', 'jquery'],
      exports: 'Backbone'
    },
    underscore: {
      exports: '_'
    },
    handlebars: {
      exports: 'Handlebars'
    }
  },
  paths: {
    bootstrap: 'lib/bootstrap',
    jquery: 'lib/jquery-1.7.2',
    jqueryAutocomplete: 'lib/jQuery.smart_autocomplete',
    underscore: 'lib/underscore',
    handlebars: 'lib/handlebars-1.0.0.beta.6',
    backbone: 'lib/backbone',
    text: 'lib/text',
    async: 'lib/async',
    templates: '../templates'
  }
});

require(['jquery', 'underscore', 'backbone', 'router', 'bootstrap'], function ($, _, Backbone, Router) {

  window.Reitti = {};
  Reitti.Event = _.extend({}, Backbone.Events);

  $(function () {
    Reitti.Router = new Router();
    Backbone.history.start();

    if (navigator.geolocation) {
      navigator.geolocation.watchPosition(function (position) {
        Reitti.Event.trigger('position:updated', position);
      }, function () {
      }, {enableHighAccuracy: true});
    }
  });
});
