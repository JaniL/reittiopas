define ->
  class Utils

    @transportColors =
      walk: '#1e74fc'
      1:    '#193695' # Helsinki internal bus lines
      2:    '#00ab66' # Trams
      3:    '#193695' # Espoo internal bus lines
      4:    '#193695' # Vantaa internal bus lines
      5:    '#193695' # Regional bus lines
      6:    '#fb6500' # Metro
      7:    '#00aee7' # Ferry
      8:    '#193695' # U-lines
      12:   '#ce1141' # Commuter trains
      21:   '#193695' # Helsinki service lines
      22:   '#193695' # Helsinki night buses
      23:   '#193695' # Espoo service lines
      24:   '#193695' # Vantaa service lines
      25:   '#193695' # Region night buses
      36:   '#193695' # Kirkkonummi internal bus lines
      39:   '#193695' # Kerava internal bus lines
      
    @isLocalStorageEnabled: -> 
      typeof(Storage) isnt "undefined"

    # From yyyyMMddHHmmss to Date
    @parseDateTime: (str) ->
      [all, year, month, date, hour, min] = str.match /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})/
      new Date year, month, date, hour, min
      
    # From Date to H:mm
    @formatTime: (d) ->
      minZero = if d.getMinutes() < 10 then '0' else ''
      "#{d.getHours()}:#{minZero}#{d.getMinutes()}"
          
    # From a numeric distance in meters to a formatted value
    @formatDistance: (d) ->
      if d < 900
        "#{d}m"
      else if d < 100000
        km = (d / 1000).toPrecision(2).replace '.', ','
        "#{km}km"
      else
        km = (d / 1000).toPrecision(3).replace '.', ','
        "#{km}km"  

    # Checks if the given geoposition is within the bounds supported
    # by this application (Greater Helsinki Area)
    @isWithinBounds: (location) ->
      {longitude: lng, latitude: lat} = location.coords
      24.152104 < lng < 25.535784 and 59.99907 < lat < 60.446654
