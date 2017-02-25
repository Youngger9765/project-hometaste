# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class RichMarkerBuilder extends Gmaps.Google.Builders.Marker #inherit from builtin builder
  #override create_marker method
  create_marker: ->
    options = _.extend @marker_options(), @rich_marker_options()
    @serviceObject = new RichMarker options #assign marker to @serviceObject

  rich_marker_options: ->
    marker = document.createElement("div")
    marker.setAttribute 'class', 'marker_container infoBox'
#    marker.innerHTML = @args.marker_title
    @marker = marker
    { content: marker }


  create_infowindow: ->
    return null unless _.isString @args.infowindow
    boxText = document.createElement("div")
    boxText.setAttribute('class', 'marker_container gmap_card') #to customize
    boxText.innerHTML = @args.html
    @infowindow = new InfoBox(@infobox(boxText))

  infobox: (boxText)->
    content: boxText
    disableAutoPan: false
    maxWidth: 0
    pixelOffset: new google.maps.Size(-140, 0)
    boxStyle:
      opacity: 1
      width: "280px"
#    closeBoxMargin: "10px 2px 2px 2px"
    closeBoxURL: @args.close_url
    infoBoxClearance: new google.maps.Size(1, 1)
    isHidden: false
    pane: "floatPane"
    enableEventPropagation: false


@buildMap = (markers)->
  handler = Gmaps.build 'Google', { builders: { Marker: RichMarkerBuilder} } #dependency injection
  #then standard use
  handler.buildMap { provider: {}, internal: {id: 'map'} }, ->
    markers = handler.addMarkers(markers)
    handler.bounds.extendWith(markers)
    handler.fitMapToBounds()
    prevent_prerender = false
    google.maps.event.addListener handler.getMap(), 'idle', ->
      show_card_num = $('.gmap_card').size()
      ne = this.getBounds().getNorthEast().toString()
      sw = this.getBounds().getSouthWest().toString()

      coordinate = deal_coordinate(ne,sw)

#      if prevent_prerender && check_in_bound(coordinate) && show_card_num == 0
      if prevent_prerender && check_in_bound(coordinate)
        rerender_map(coordinate)
      prevent_prerender = true


check_in_bound=(coordinate) ->
  console.log(coordinate['n']-coordinate['s'],coordinate['e']-coordinate['w'])
  a = (coordinate['n']-coordinate['s'] < 0.125 && coordinate['e']-coordinate['w'] < 0.421)
  b = ( 0.003 < coordinate['n']-coordinate['s'] && 0.015 < coordinate['e']-coordinate['w'])
  a && b

deal_coordinate=(ne,sw) ->
  n = +(ne.replace(/\(|\)/g,'').split(',')[0])
  e = +(ne.replace(/\(|\)/g,'').split(',')[1])
  s = +(sw.replace(/\(|\)/g,'').split(',')[0])
  w = +(sw.replace(/\(|\)/g,'').split(',')[1])
  {n:n,e:e,s:s,w:w}

rerender_map=(coordinate)->
  qty = 9
  qty = 8 if $(window).width() < 992
  $.ajax
    type: 'GET',
    url: '/api/v1/getRestaurantsByMap',
    data:
      north:coordinate['n'],
      east:coordinate['e'],
      south:coordinate['s'],
      west:coordinate['w'],
      qty:qty
    success: (data)->
      if data.qty > 0
        buildMap(data.gmap_hash)
