if @hash
  byebug
  json.array!(@hash) do |h|
    json.lat h.lat
    json.lng h.lng
    json.infowindow h.infowindow
    json.description h.description
    json.english_description h.english_description
    json.image_url h.image_url
    json.tag_id h.tag_id
    json.is_active h.is_active
    json.lang_id h.lang_id
  end
end
