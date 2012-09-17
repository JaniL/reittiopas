define [], ->

  class MapMarkerImage extends google.maps.Marker

    constructor: (map, latLng, legType) ->
      @setMap(map)
      @setPosition(latLng)
      @setIcon(@_markerImage(legType))

    _markerImage: (legType) ->
      if legType is 'walk'
        new google.maps.MarkerImage '/img/walker_texas_ranger_small.png', @_imageSize(), new google.maps.Point(0, 0), new google.maps.Point(0, 0)
      else
        new google.maps.MarkerImage '/img/vehicles_small.png', @_imageSize(), @_imageOrigin(legType), @_imageAnchor()


    _imageOrigin: (legType) ->
      switch legType
        when '2' then new google.maps.Point(32, 32)
        when '6' then new google.maps.Point(0, 32)
        when '7' then new google.maps.Point(0, 64)
        when '12' then new google.maps.Point(32, 0)
        else new google.maps.Point(0, 0)

    _imageSize: ->
      @imageSize ?= new google.maps.Size 32, 32, 'px', 'px'

    _imageAnchor: ->
      @imageAnchor ?= new google.maps.Point 16, 16
