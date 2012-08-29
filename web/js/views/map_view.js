define(['jquery', 'async!http://maps.googleapis.com/maps/api/js?sensor=true' + (window.location.host === 'localhost' ? '' : '&key=AIzaSyDZj9_A4WUDGph6cKf2A7VsFbDz6Pb7QBk')], function($) {
  return Backbone.View.extend({

    el: $('#map'),

    render: function() {
      this.map = new google.maps.Map(this.el, {
        center: new google.maps.LatLng(60.200833, 24.9375), // Helsinki
        zoom: 12,
        center: new google.maps.LatLng(60.171, 24.941), // Rautatieasema
        zoom: 16,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        mapTypeControlOptions: {
          position: google.maps.ControlPosition.TOP_CENTER
        }
      });
      this.centerOnCurrentLocation();

      return this;
    },

    centerOnCurrentLocation: function () {
      if (navigator.geolocation) {
        var that = this;
        navigator.geolocation.getCurrentPosition(function (position) {
          var latLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
          that.map.setCenter(latLng);
        });
      }
    }

  });
});
