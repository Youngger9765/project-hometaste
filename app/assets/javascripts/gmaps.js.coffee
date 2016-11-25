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
      if prevent_prerender && show_card_num == 0
        rerender_map(this)
      prevent_prerender = true


rerender_map=(data)->
  ne = data.getBounds().getNorthEast().toString()
  sw = data.getBounds().getSouthWest().toString()
  qty = 9
  qty = 8 if $(window).width() < 992
  $.ajax
    type: 'GET',
    url: '/api/v1/getRestaurantsByMap',
    data:
      north_east:ne,
      south_west:sw
      qty:qty
    success: (data)->
      buildMap(data.gmap_hash)