$ ->
  $('.product_images').on 'click', 'a', (event) ->
    event.preventDefault()

    $('.primary_image').prop 'src', $(this).prop('href')
    $('.product_images li.selected').removeClass 'selected'
    $(this).closest('li').addClass 'selected'
