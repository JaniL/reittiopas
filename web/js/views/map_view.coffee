define [
  'jquery'
  'underscore'
  'backbone'
  'views/map_route_view'
  'async!http://maps.googleapis.com/maps/api/js?sensor=true' + if window.location.host is 'localhost' then '' else '&key=AIzaSyDZj9_A4WUDGph6cKf2A7VsFbDz6Pb7QBk'
], ($, _, Backbone, MapRouteView) ->
      
  class MapView extends Backbone.View

    el: $('#map')

    initialize: ->
      @routeView = new MapRouteView
      
      # If we already have the user's current position, use it. If not, center
      # the map to it as soon as everything is initialized and we have the
      # location.
      if window.initialPosition
        @currentPosition = new google.maps.LatLng(window.initialPosition.coords.latitude,
          window.initialPosition.coords.longitude)
      else
        Reitti.Event.on 'position:change', (position) =>
          _.once @centerMap(position)

      Reitti.Event.on 'position:change', (position) =>
        @displayCurrentPosition position

      Reitti.Event.on 'route:change', @drawRoute, @


    render: ->
      @map = new google.maps.Map(@el,
        center: @currentPosition or new google.maps.LatLng(60.171, 24.941) # Rautatieasema
        zoom: 16
        mapTypeId: google.maps.MapTypeId.ROADMAP
        mapTypeControlOptions:
          position: google.maps.ControlPosition.TOP_CENTER
      )
      @

    drawRoute: (route) ->
      @routeView.remove()
      @routeView.render route, @map
      @panToRouteBounds()

    panToRouteBounds: () ->
      @map.fitBounds @routeView.getBounds()

    centerMap: (position) ->
      latLng = new google.maps.LatLng position.coords.latitude, position.coords.longitude
      @map.setCenter latLng

    displayCurrentPosition: (position) ->
      latLng   = new google.maps.LatLng position.coords.latitude, position.coords.longitude
      accuracy = position.coords.accuracy

      @positionIndicator ?= new google.maps.Circle(
        strokeColor: '#0000FF'
        strokeOpacity: 0.50
        strokeWeight: 2
        fillColor: '#0000FF'
        fillOpacity: 0.10
        map: @map
        center: latLng
        radius: accuracy
      )
      @positionIndicator.setCenter latLng
      @positionIndicator.setRadius accuracy