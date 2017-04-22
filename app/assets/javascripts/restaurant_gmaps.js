var build_map = function (coordinates){
  handler = Gmaps.build('Google');
  handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
    markers = handler.addMarkers([
      {
        "lat": coordinates[0],
        "lng": coordinates[1],
      }
    ]);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
    handler.getMap().setZoom(19);
  });
};

var coordinates = $('.bulk_location').eq(0).data('coordinates')
build_map(coordinates)

$('.bulk_location').click(function(){
  var coordinates = $(this).data('coordinates')
  build_map(coordinates)
})

