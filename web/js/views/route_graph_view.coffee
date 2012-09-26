define ['underscore', 'backbone', 'utils', 'handlebars', 'hbs!template/route_graph'], (_, Backbone, Utils, Handlebars, template) ->

  EXPANDED_HEIGHT = 150
  MINIMUM_LEG_HEIGHT = 12

  # ToDo: Legs really deserve their own view class at this point.
  EXPANDED_HEIGHT = 25

  class RouteGraphView extends Backbone.View

    events:
      'click .leg-info': 'selectLeg'

    initialize: (routes: routes, routeParams: routeParams, index: index) ->
      @routes = routes
      @routeParams = routeParams
      @index = index
      @route = routes.at(@index)
      @expanded = false

    render: ->
      @$el.html template(legs: @_legData())
      this

    selectLeg: (e) =>
      idx = $(e.target).closest('[data-leg]').data('leg')
      Reitti.Router.navigateToRoutes _.extend(@routeParams, legIndex: idx)
      false

    onRoutesChanged: (routes, routeParams) =>
      isThis = routes is @routes and routeParams.routeIndex is @index
      @expandOrCollapse isThis
      @$el.find('[data-leg]').removeClass 'selected'
      if isThis and routeParams.legIndex?
        @$el.find("[data-leg=#{routeParams.legIndex}]").addClass 'selected'

    expandOrCollapse: (expanded) =>
      if @expanded isnt expanded
        @expanded = expanded
        @$el.toggleClass 'expanded', @expanded
        if @expanded then @_expand() else @_collapse()

    _expand: () ->
      numberOfLegs = @route.get('legs').length
      totalHeight = EXPANDED_HEIGHT * numberOfLegs
      @$el.css 'height', totalHeight + 6
      @_moveLegsToTheSide()
      @_showLegInfos()

    _collapse: () ->
      @$el.css height: ''
      @_moveLegsToTheTop()
      @_hideLegInfos()

    _moveLegsToTheSide: (legHeights) ->
      cumulativeHeight = 0
      for leg, index in @$el.find('.leg[data-leg]')
        $(leg).data
          collapsedLeft: $(leg).css 'left'
          collapsedWidth: $(leg).css 'width'
        $(leg).css
          top: cumulativeHeight
          height: EXPANDED_HEIGHT - 1 # Leave one pixel for the "gutter"
          left: 0
          width: "#{EXPANDED_HEIGHT}px"
        $('.leg-bar', leg).css 'height', EXPANDED_HEIGHT - 5 # gutter + 2 x padding (ToDO: this isn't the place for this sort of thing)
        cumulativeHeight += EXPANDED_HEIGHT

    _moveLegsToTheTop: () ->
      for leg in @$el.find('.leg[data-leg]')
        $(leg).css
          top: '0'
          left: $(leg).data 'collapsedLeft'
          width: $(leg).data 'collapsedWidth'
          height: ''
        $('.leg-bar', leg).css height: ''

    _showLegInfos: () ->
      cumulativeHeight = 0
      for legInfo, index in @$el.find('.leg-info[data-leg]')
        $(legInfo).show().css top: Math.floor(cumulativeHeight), height: "#{EXPANDED_HEIGHT-1}px"
        $('*', legInfo).css 'lineHeight', "#{EXPANDED_HEIGHT-1}px"
        cumulativeHeight += EXPANDED_HEIGHT

    _hideLegInfos: () ->
      @$el.find('.leg-info').hide()

    _legData: () ->
      cumulativePercentage = 0
      for leg,legIdx in @route.get('legs')
        percentage = @routes.getLegDurationPercentage(@index, legIdx)
        percentageBefore = cumulativePercentage
        cumulativePercentage += percentage

        {
          type: leg.get('type')
          indicator: @_legIndicator(leg)
          times: @_timeLabel(leg, legIdx)
          transport: @_transportLabel(leg)
          destination: @_destinationLabel(leg, legIdx)
          firstArrivalTime: Utils.formatTimeForHumans(leg.firstArrivalTime())
          destinationName: @_destinationLabel(leg, legIdx)
          color: Utils.transportColors[leg.get('type')]
          percentage: percentage
          percentageBefore: percentageBefore
          iconVisible: percentage > 5
        }

    _legIndicator: (leg) ->
      switch leg.get('type')
        when 'walk' then ''
        else leg.lineName()


    _timeLabel: (leg) ->
      "#{Utils.formatTimeForHumans(leg.firstArrivalTime())} - #{Utils.formatTimeForHumans(leg.lastArrivalTime())}"

    _destinationLabel: (leg, legIdx) ->
      if leg is @route.lastLeg()
          to = @routes.toName
          cityIdx = to.lastIndexOf(',')
          if cityIdx < 0 then to else to.substring(0, cityIdx)
       else
         leg.destinationName()

    _transportLabel: (leg) ->
      type = leg.get('type')
      content = switch type
        when 'walk' then "#{@_transportTypeLabel(type)}, #{Utils.formatDistance(leg.get('length'))}"
        when '6','7' then "<strong>#{@_transportTypeLabel(type)}</strong>"
        when '12' then "<strong>#{leg.lineName()}-#{@_transportTypeLabel(type)}</strong>"
        else  "<strong>#{leg.lineName()}</strong>"
      new Handlebars.SafeString content

    # TODO: This should be somewhere in i18n
    _transportTypeLabel: (type) ->
      switch type
        when 'walk' then 'Kävely'
        when '2' then "Ratikka"
        when '6' then "Metro"
        when '7' then "Lautta"
        when '12' then "Juna"
        else "bussi"

