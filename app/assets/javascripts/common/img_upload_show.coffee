$(document).ready ->
  $('.img_upload input[type=file]').on 'change', (event) ->
    files = event.target.files;
    image = files[0]
    reader = new FileReader();
    reader.onload = (file) ->
      img = new Image();
      img.src = file.target.result;
      $(event.target).siblings('label').css("background-image","url(" + img.src + ")").addClass('hover')

    reader.readAsDataURL(image);
