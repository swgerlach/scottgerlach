# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

desired_temp = 72
CURRENT_TEMP = 72
timeout = 0
mode = 'MAIN'
fan_mode = true
home_comfort_max = 80
home_comfort_min = 60
away_comfort_max = 85
away_comfort_min = 55

$.fn.extend stopAll: ->
  @stop false, true  while @queue().length > 0
  this

increaseTemp = () ->
  if desired_temp < 99
    new_temp = desired_temp + 1
    cleanPegs()
    $("#peg-" + new_temp).addClass('peg-white').addClass('enlarged')
    $("#peg-" + desired_temp).removeClass('peg-white').removeClass('enlarged')
    switchToDesired(desired_temp, new_temp)
    desired_temp = new_temp



decreaseTemp = () ->
  if desired_temp > 41
    new_temp = desired_temp - 1
    cleanPegs()
    $("#peg-" + new_temp).addClass('peg-white').addClass('enlarged')
    $("#peg-" + desired_temp).removeClass('peg-white').removeClass('enlarged')
    switchToDesired(desired_temp, new_temp)
    desired_temp = new_temp



firstTempChange = () ->
  $(".triangle-pointer, .desired-temp-wrapper").css
    'transform' : "rotate(" + (desired_temp-70)*3 + "deg)"
  $(".triangle-pointer, .desired-temp-wrapper").show()



switchToDesired = (desired_t, new_t) ->
  $('#press-for-menu').hide()
  $(".temp-band-indicator").hide()
  $(".desired-temp").text(new_t)
  $(".temp-band-range-home").fadeIn()
  $(".temp-band-range-home p").fadeIn()
  $(".triangle-pointer, .desired-temp-wrapper").show()
  $(".current-temp").transition
    top: '240px'
    left: '240px'
    fontSize: '14px'
    , 250, ->
      $(".current-temp, .current-temp-sub").hide()
      $('#press-to-confirm').fadeIn(250)
  if !($(".desired-temp-wrapper").is(':visible'))
    firstTempChange()
  $(".desired-temp").transition
    display: 'inline'
    fontSize: '130px'
    lineHeight: '100px'
    padding: '5px 10px 0'
    top: '115px'
    , 250, ->
      $(".desired-temp-sub").show()
  $(".desired-temp-wrapper").transition
    left: '100px'
    rotate: 0
    , 250
  $("#triangle-img").transition
    width: '22px'
    height: '144px'
    margin: '0'
    , 250
  peg_position = $("#peg-" + new_t).position()
  $(".triangle-pointer").css
    'transform' : "rotate(" + (new_t-70)*3 + "deg)"



switchToCurrent = () ->
  $('#press-to-confirm').hide()
  $("#peg-" + desired_temp).removeClass('enlarged')
  $(".desired-temp-sub").hide()
  $(".temp-band-range-home").fadeOut()
  $(".current-temp-sub, .current-temp").show()
  $(".current-temp").transition
    top: '75px'
    left: '110px'
    fontSize: '130px'
    , 250
  $(".desired-temp").transition
    fontSize : '20px'
    lineHeight : '20px'
    padding : '3px 6px 1px'
    top : '45px'
    , 250
  $(".desired-temp-wrapper").transition
    rotate: ((desired_temp-70)*3)
    left : "165px"
    , 250
  $("#triangle-img").transition
    width: '8px'
    height: '30px'
    margin: '0 8px'
    , 250 , ->
      $('#press-for-menu').fadeIn()
      showDesiredIndicator()
      animateBand()


animateBand = () ->
  animate_list = [CURRENT_TEMP..desired_temp]
  animate_list.pop()
  for i in animate_list
    delay_factor = ( Math.abs(CURRENT_TEMP - i) ) * 100
    animationPeg(i)



animationPeg = (i) ->
      $("#peg-" + i).addClass('peg-white')
      $("#peg-" + i).transition
        opacity: Math.abs(CURRENT_TEMP - i)/Math.abs(CURRENT_TEMP - desired_temp)*.2 + .8

showDesiredIndicator = () ->
  $(".desired-temp-wrapper").show()
  if (desired_temp == CURRENT_TEMP)
    $(".triangle-pointer, .desired-temp-wrapper, .temp-band-indicator").hide()
  else
    if (desired_temp < CURRENT_TEMP)
      $(".triangle-pointer, .desired-temp-wrapper, .desired-temp, .temp-band-indicator").fadeIn()
      $("#heat-cool").attr('src', 'assets/cooling-ind.png').fadeIn()
      $(".temp-band-indicator").css(
        'transform' : "rotate(" + (desired_temp-70)*3 + "deg)"
        ).fadeIn()
    if (desired_temp > CURRENT_TEMP)
      $(".triangle-pointer, .desired-temp-wrapper, .desired-temp, .temp-band-indicator").fadeIn()
      $("#heat-cool").attr('src', 'assets/heating-ind.png').fadeIn()
      $(".temp-band-indicator").css(
        'transform' : "rotate(" + (desired_temp-70)*3 + "deg)"
        ).fadeIn()


shrinkTransitionalCircle = () ->
  $('.transition-circle').show()
  $('.transition-circle').transition
    border : '35px solid #999999'
    margin : '0'
    , 300, 'ease', ->
      $(this).transition
        border : '0px solid #999999'
        margin: '35px'
      , 400, 'ease', ->
        $(this).css
          'background' : 'none'
          'opacity' : '1'
          'z-index' : '98'
          'height' : '290px'
          'width' : '290px'
          'margin' : '35px'
          'top' : '0px'
          'left' : '0px'
  $('.transition-circle').hide()

revealMenu = () ->
  $('.transition-circle').show()
  $('.transition-circle').transition
    border : '35px solid #999999'
    margin: '0'
    , 300, 'ease', ->
      $('.temp-band, .temp-band-indicator, .desired-temp, .triangle-pointer').hide()
      $('.menu-band').show()
      $('#menu-exit').show()
      $(this).transition
        border : '0px solid #999999'
        margin: '35px'
      , 400, 'ease', ->
        $(this).css
          'background' : '#000000'
          'opacity' : '.5'
          'z-index' : '98'
          'height' : '360px'
          'width' : '360px'
          'margin' : '0'

hideMenu = () ->
  $('#press-to-adjust').hide()
  $('.transition-circle').css
    'background' : 'none'
    'opacity' : '1'
    'z-index' : '100'
    'height' : '290px'
    'width' : '290px'
    'margin' : '35px'
  $('.transition-circle').transition
    border : '35px solid #999999'
    margin: '0px'
    , 300, 'ease', ->
      if (mode == 'MENU-EXIT')
        $('.temp-band').show()
        $('.menu-band').hide()
        $('#menu').hide()
        $(this).transition
          border : '0px solid #999999'
          margin: '35px'
          , 400, 'ease', ->
          if desired_temp != CURRENT_TEMP
            $('.desired-temp-wrapper, .desired-temp, .triangle-pointer').show()
            $('.temp-band-indicator').fadeIn(2000)
        return
      else if (mode == 'MENU-HOME')
        $('.temp-band').show()
        $('.menu-band').hide()
        $('#menu').hide()
        $(this).transition
          border : '0px solid #999999'
          margin: '35px'
          , 400, 'ease', ->
            showHome()
        return
      else if (mode == 'MENU-AWAY')
        $('.temp-band').show()
        $('.menu-band').hide()
        $('#menu').hide()
        $(this).transition
          border : '0px solid #999999'
          margin: '35px'
          , 400, 'ease', ->
            showAway()
        return
      else if (mode == 'MENU-FAN')
        $('.menu-band').hide()
        $('#menu').hide()
        $(this).transition
          border : '0px solid #999999'
          margin: '35px'
          , 400, 'ease'
        return


showMain = () ->
  $('.main-display').fadeIn 1000, ->
    showDesiredIndicator()
    $(".current-temp, .temp-band").show()
    $('#press-for-menu').fadeIn()
  $('#menu, #menu-exit, #menu-home, #menu-away, #menu-fan').hide()
  $('.temp-band-indicator').hide()
  return

showHome = () ->
  cleanPegs()
  $('.range-max-home p, .range-min-home p').css
    'font-size' : '28px'
    'left' : '164px'
  $('.range-min-home p').removeClass('text-shadow-gray').addClass('text-shadow-black')
  $('.range-min-home img.large-arc').show()
  $('.range-max-home img.small-arc').show()
  $('.exit-home').show()
  $('.exit-home img.small-arc').show()
  $('.temp-band-range-home').show()
  $('.temp-band-range-home p').show()
  return

hideHome = () ->
  $('.range-max-home p, .range-min-home p').transition
    'font-size' : '20px'
    'left' : '167px'
    , 250, 'ease', ->
      $(this).fadeOut(1000)
  $('.range-min-home p').removeClass('text-shadow-black').addClass('text-shadow-gray')
  $('.range-max-home p').removeClass('text-shadow-black').addClass('text-shadow-gray')
  $('.exit-home p').removeClass('text-shadow-black').addClass('text-shadow-gray')
  $('.range-min-home img').hide()
  $('.range-max-home img').hide()
  $('.exit-home img').hide()
  $('.exit-home').hide()
  $('.home-display').hide()
  return

rotateHomeMenuCW = () ->
  if $('.range-min-home img.large-arc').is(':visible')
    $('.range-min-home img.large-arc').hide()
    $('.range-min-home img.small-arc').show()
    $('.range-min-home p').removeClass('text-shadow-black').addClass('text-shadow-gray')
    $('.range-max-home img.small-arc').hide()
    $('.range-max-home img.large-arc').show()
    $('.range-max-home p').removeClass('text-shadow-gray').addClass('text-shadow-black')
    return
  else if $('.range-max-home img.large-arc').is(':visible')
    $('.range-max-home img.large-arc').hide()
    $('.range-max-home img.small-arc').show()
    $('.range-max-home p').removeClass('text-shadow-black').addClass('text-shadow-gray')
    $('.exit-home img.small-arc').hide()
    $('.exit-home img.large-arc').show()
    $('.exit-home p').removeClass('text-shadow-gray').addClass('text-shadow-black')
    return
  else if $('.exit-home img.large-arc').is(':visible')
    $('.exit-home img.large-arc').hide()
    $('.exit-home img.small-arc').show()
    $('.exit-home p').removeClass('text-shadow-black').addClass('text-shadow-gray')
    $('.range-min-home img.small-arc').hide()
    $('.range-min-home img.large-arc').show()
    $('.range-min-home p').removeClass('text-shadow-gray').addClass('text-shadow-black')
    return

rotateHomeMenuCCW = () ->
  if $('.range-min-home img.large-arc').is(':visible')
    $('.range-min-home img.large-arc').hide()
    $('.range-min-home img.small-arc').show()
    $('.range-min-home p').removeClass('text-shadow-black').addClass('text-shadow-gray')
    $('.exit-home img.small-arc').hide()
    $('.exit-home img.large-arc').show()
    $('.exit-home p').removeClass('text-shadow-gray').addClass('text-shadow-black')

    return
  else if $('.exit-home img.large-arc').is(':visible')
    $('.exit-home img.large-arc').hide()
    $('.exit-home img.small-arc').show()
    $('.exit-home p').removeClass('text-shadow-black').addClass('text-shadow-gray')
    $('.range-max-home img.small-arc').hide()
    $('.range-max-home img.large-arc').show()
    $('.range-max-home p').removeClass('text-shadow-gray').addClass('text-shadow-black')
    return
  else if $('.range-max-home img.large-arc').is(':visible')
    $('.range-max-home img.large-arc').hide()
    $('.range-max-home img.small-arc').show()
    $('.range-max-home p').removeClass('text-shadow-black').addClass('text-shadow-gray')
    $('.range-min-home img.small-arc').hide()
    $('.range-min-home img.large-arc').show()
    $('.range-min-home p').removeClass('text-shadow-gray').addClass('text-shadow-black')
    return

showRangeHandleHome = (target) ->
  $('img.large-arc, img.small-arc').hide()
  if target == home_comfort_min
    $('.range-min-home .bg-circle').show()
  else if target == home_comfort_max
    $('.range-max-home .bg-circle').show()
  $('#peg-'+target).addClass('peg-black').addClass('enlarged')
  $('.exit-home').hide()
  $('#press-to-confirm').fadeIn()

hideRangeHandleHome = (target) ->
  if target == home_comfort_min
    $('.range-min-home img.large-arc').show()
    $('.range-max-home img.small-arc').show()
    $('.exit-home img.small-arc').show()
    $('.range-min-home .bg-circle').hide()
  else if target == home_comfort_max
    $('.range-min-home img.small-arc').show()
    $('.range-max-home img.large-arc').show()
    $('.exit-home img.small-arc').show()
    $('.range-max-home .bg-circle').hide()
  $('#peg-'+target).removeClass('peg-black').removeClass('enlarged')
  $('.exit-home').show()
  $('#press-to-confirm').hide()

adjustRangeUp = (target) ->
  $('#peg-'+target).removeClass('peg-black').removeClass('enlarged')
  target += 1
  $('#peg-'+(target)).addClass('peg-black').addClass('enlarged')
  if home_comfort_min == target - 1
    $('#peg-'+(target-1)).addClass('peg-dgray')
    $('.range-min-home p').text(target)
    $('.range-min-home').css
      'transform' : "rotate(" + (target-70)*3 + "deg)"
  else if home_comfort_max == target - 1
    $('#peg-'+(target-1)).removeClass('peg-dgray')
    $('.range-max-home p').text(target)
    $('.range-max-home').css
      'transform' : "rotate(" + (target-70)*3 + "deg)"
  return

adjustRangeDown = (target) ->
  $('#peg-'+target).removeClass('peg-black').removeClass('enlarged').removeClass('peg-dgray')
  target += -1
  $('#peg-'+(target)).addClass('peg-black').addClass('enlarged')
  if home_comfort_min == target + 1
    $('#peg-'+(target+1)).removeClass('peg-dgray')
    $('.range-min-home p').text(target)
    $('.range-min-home').css
      'transform' : "rotate(" + (target-70)*3 + "deg)"
  else if home_comfort_max == target + 1
    $('#peg-'+(target+1)).addClass('peg-dgray')
    $('.range-max-home p').text(target)
    $('.range-max-home').css
      'transform' : "rotate(" + (target-70)*3 + "deg)"
  return



showAway = () ->
  cleanPegsAway()
  setRangeIndicatorsAway()
  # set range pegs
  range_index = [40..away_comfort_min].concat([away_comfort_max..100])
  for i in range_index
    $("#peg-" + i).addClass('peg-dgray')

  $('.range-max-away p, .range-min-away p').css
    'font-size' : '28px'
    'left' : '164px'
  $('.range-min-away p').removeClass('text-shadow-gray').addClass('text-shadow-black')
  $('.range-min-away img.large-arc').show()
  $('.range-max-away img.small-arc').show()
  $('.exit-away').show()
  $('.exit-away img.small-arc').show()
  $('.temp-band-range-away').show()
  $('.temp-band-range-away p').show()
  return

hideAway = () ->
  $('.range-max-away p, .range-min-away p').transition
    'font-size' : '20px'
    'left' : '167px'
    , 250, 'ease', ->
      $(this).fadeOut(1000)
  $('.range-min-away p').removeClass('text-shadow-black').addClass('text-shadow-gray')
  $('.range-max-away p').removeClass('text-shadow-black').addClass('text-shadow-gray')
  $('.exit-away p').removeClass('text-shadow-black').addClass('text-shadow-gray')
  $('.range-min-away img').hide()
  $('.range-max-away img').hide()
  $('.exit-away img').hide()
  $('.exit-away').hide()
  $('.away-display').hide()
  cleanPegs()
  # set range pegs
  range_index = [40..home_comfort_min].concat([home_comfort_max..100])
  for i in range_index
    $("#peg-" + i).addClass('peg-dgray')
  return

rotateAwayMenuCW = () ->
  if $('.range-min-away img.large-arc').is(':visible')
    $('.range-min-away img.large-arc').hide()
    $('.range-min-away img.small-arc').show()
    $('.range-min-away p').removeClass('text-shadow-black').addClass('text-shadow-gray')
    $('.range-max-away img.small-arc').hide()
    $('.range-max-away img.large-arc').show()
    $('.range-max-away p').removeClass('text-shadow-gray').addClass('text-shadow-black')
    return
  else if $('.range-max-away img.large-arc').is(':visible')
    $('.range-max-away img.large-arc').hide()
    $('.range-max-away img.small-arc').show()
    $('.range-max-away p').removeClass('text-shadow-black').addClass('text-shadow-gray')
    $('.exit-away img.small-arc').hide()
    $('.exit-away img.large-arc').show()
    $('.exit-away p').removeClass('text-shadow-gray').addClass('text-shadow-black')
    return
  else if $('.exit-away img.large-arc').is(':visible')
    $('.exit-away img.large-arc').hide()
    $('.exit-away img.small-arc').show()
    $('.exit-away p').removeClass('text-shadow-black').addClass('text-shadow-gray')
    $('.range-min-away img.small-arc').hide()
    $('.range-min-away img.large-arc').show()
    $('.range-min-away p').removeClass('text-shadow-gray').addClass('text-shadow-black')
    return

rotateAwayMenuCCW = () ->
  if $('.range-min-away img.large-arc').is(':visible')
    $('.range-min-away img.large-arc').hide()
    $('.range-min-away img.small-arc').show()
    $('.range-min-away p').removeClass('text-shadow-black').addClass('text-shadow-gray')
    $('.exit-away img.small-arc').hide()
    $('.exit-away img.large-arc').show()
    $('.exit-away p').removeClass('text-shadow-gray').addClass('text-shadow-black')

    return
  else if $('.exit-away img.large-arc').is(':visible')
    $('.exit-away img.large-arc').hide()
    $('.exit-away img.small-arc').show()
    $('.exit-away p').removeClass('text-shadow-black').addClass('text-shadow-gray')
    $('.range-max-away img.small-arc').hide()
    $('.range-max-away img.large-arc').show()
    $('.range-max-away p').removeClass('text-shadow-gray').addClass('text-shadow-black')
    return
  else if $('.range-max-away img.large-arc').is(':visible')
    $('.range-max-away img.large-arc').hide()
    $('.range-max-away img.small-arc').show()
    $('.range-max-away p').removeClass('text-shadow-black').addClass('text-shadow-gray')
    $('.range-min-away img.small-arc').hide()
    $('.range-min-away img.large-arc').show()
    $('.range-min-away p').removeClass('text-shadow-gray').addClass('text-shadow-black')
    return

showRangeHandleAway = (target) ->
  $('img.large-arc, img.small-arc').hide()
  if target == away_comfort_min
    $('.range-min-away .bg-circle').show()
  else if target == away_comfort_max
    $('.range-max-away .bg-circle').show()
  $('#peg-'+target).addClass('peg-black').addClass('enlarged')
  $('.exit-away').hide()
  $('#press-to-confirm').fadeIn()

hideRangeHandleAway = (target) ->
  if target == away_comfort_min
    $('.range-min-away img.large-arc').show()
    $('.range-max-away img.small-arc').show()
    $('.exit-away img.small-arc').show()
    $('.range-min-away .bg-circle').hide()
  else if target == away_comfort_max
    $('.range-min-away img.small-arc').show()
    $('.range-max-away img.large-arc').show()
    $('.exit-away img.small-arc').show()
    $('.range-max-away .bg-circle').hide()
  $('#peg-'+target).removeClass('peg-black').removeClass('enlarged')
  $('.exit-away').show()
  $('#press-to-confirm').hide()

adjustRangeUpAway = (target) ->
  $('#peg-'+target).removeClass('peg-black').removeClass('enlarged')
  target += 1
  $('#peg-'+(target)).addClass('peg-black').addClass('enlarged')
  if away_comfort_min == target - 1
    $('#peg-'+(target-1)).addClass('peg-dgray')
    $('.range-min-away p').text(target)
    $('.range-min-away').css
      'transform' : "rotate(" + (target-70)*3 + "deg)"
  else if away_comfort_max == target - 1
    $('#peg-'+(target-1)).removeClass('peg-dgray')
    $('.range-max-away p').text(target)
    $('.range-max-away').css
      'transform' : "rotate(" + (target-70)*3 + "deg)"
  return

adjustRangeDownAway = (target) ->
  $('#peg-'+target).removeClass('peg-black').removeClass('enlarged').removeClass('peg-dgray')
  target += -1
  $('#peg-'+(target)).addClass('peg-black').addClass('enlarged')
  if away_comfort_min == target + 1
    $('#peg-'+(target+1)).removeClass('peg-dgray')
    $('.range-min-away p').text(target)
    $('.range-min-away').css
      'transform' : "rotate(" + (target-70)*3 + "deg)"
  else if away_comfort_max == target + 1
    $('#peg-'+(target+1)).addClass('peg-dgray')
    $('.range-max-away p').text(target)
    $('.range-max-away').css
      'transform' : "rotate(" + (target-70)*3 + "deg)"
  return

showFan = () ->
  $('.fan-menu, .fan-display').show()
  $('.auto-fan img.black, .on-fan img.gray, .off-fan img.gray, .exit-fan img.gray').show()
  $('.auto-fan img.large-arc').show()
  $('.auto-fan img.small-arc').hide()
  $('.on-fan img.large-arc').hide()
  $('.on-fan img.small-arc').show()
  $('.off-fan img.large-arc').hide()
  $('.off-fan img.small-arc').show()
  $('.exit-fan img.large-arc').hide()
  $('.exit-fan img.small-arc').show()
  return

hideFan = () ->
  $('.fan-menu, .fan-display').hide()
  return

switchFan = (target) ->
  $('.fan-indicator').transition
    x: '+=-150'
    opacity: '0'
    , 250 , ->
      $(this).text(target).transition
        x: '+=300'
        ,50, ->
          $(this).transition
            x: '+=-150'
            opacity: '1'
  return

rotateFanMenuCW = () ->
  if $('.auto-fan img.large-arc').is(':visible')
    $('.auto-fan img.large-arc').hide()
    $('.auto-fan img.small-arc').show()
    $('.auto-fan img.gray').show()
    $('.auto-fan img.black').hide()
    $('.on-fan img.large-arc').show()
    $('.on-fan img.small-arc').hide()
    $('.on-fan img.gray').hide()
    $('.on-fan img.black').show()
    return
  else if $('.on-fan img.large-arc').is(':visible')
    $('.on-fan img.large-arc').hide()
    $('.on-fan img.small-arc').show()
    $('.on-fan img.gray').show()
    $('.on-fan img.black').hide()
    $('.off-fan img.large-arc').show()
    $('.off-fan img.small-arc').hide()
    $('.off-fan img.gray').hide()
    $('.off-fan img.black').show()
    return
  else if $('.off-fan img.large-arc').is(':visible')
    $('.off-fan img.large-arc').hide()
    $('.off-fan img.small-arc').show()
    $('.off-fan img.gray').show()
    $('.off-fan img.black').hide()
    $('.exit-fan img.large-arc').show()
    $('.exit-fan img.small-arc').hide()
    $('.exit-fan img.gray').hide()
    $('.exit-fan img.black').show()
    return
  else if $('.exit-fan img.large-arc').is(':visible')
    $('.exit-fan img.large-arc').hide()
    $('.exit-fan img.small-arc').show()
    $('.exit-fan img.gray').show()
    $('.exit-fan img.black').hide()
    $('.auto-fan img.large-arc').show()
    $('.auto-fan img.small-arc').hide()
    $('.auto-fan img.gray').hide()
    $('.auto-fan img.black').show()
    return

rotateFanMenuCCW = () ->
  if $('.auto-fan img.large-arc').is(':visible')
    $('.auto-fan img.large-arc').hide()
    $('.auto-fan img.small-arc').show()
    $('.auto-fan img.gray').show()
    $('.auto-fan img.black').hide()
    $('.exit-fan img.large-arc').show()
    $('.exit-fan img.small-arc').hide()
    $('.exit-fan img.gray').hide()
    $('.exit-fan img.black').show()
    return
  else if $('.exit-fan img.large-arc').is(':visible')
    $('.exit-fan img.large-arc').hide()
    $('.exit-fan img.small-arc').show()
    $('.exit-fan img.gray').show()
    $('.exit-fan img.black').hide()
    $('.off-fan img.large-arc').show()
    $('.off-fan img.small-arc').hide()
    $('.off-fan img.gray').hide()
    $('.off-fan img.black').show()
    return
  else if $('.off-fan img.large-arc').is(':visible')
    $('.off-fan img.large-arc').hide()
    $('.off-fan img.small-arc').show()
    $('.off-fan img.gray').show()
    $('.off-fan img.black').hide()
    $('.on-fan img.large-arc').show()
    $('.on-fan img.small-arc').hide()
    $('.on-fan img.gray').hide()
    $('.on-fan img.black').show()
    return
  else if $('.on-fan img.large-arc').is(':visible')
    $('.on-fan img.large-arc').hide()
    $('.on-fan img.small-arc').show()
    $('.on-fan img.gray').show()
    $('.on-fan img.black').hide()
    $('.auto-fan img.large-arc').show()
    $('.auto-fan img.small-arc').hide()
    $('.auto-fan img.gray').hide()
    $('.auto-fan img.black').show()
    return


setPegOpacity = () ->
  peg_opac_index = [40,41,42,43,97,98,99,100]
  for i in peg_opac_index
    $("#peg-" + i).css
      'opacity' : (30 - Math.abs(70-i))*.25


elemToggle = (str1, str2) ->
  $(str1).toggle()
  $(str2).toggle()



cleanPegs = () ->
  peg_index = [40..100]
  for i in peg_index
    $("#peg-" + i).removeClass('peg-white').removeClass('enlarged').css
      opacity: '1'
  setPegOpacity()
  $("#peg-" + desired_temp).addClass('peg-white')

cleanPegsAway = () ->
  peg_index = [40..100]
  for i in peg_index
    $("#peg-" + i).removeClass('peg-white').removeClass('peg-dgray').removeClass('enlarged').css
      opacity: '1'
  setPegOpacity()
  $("#peg-" + desired_temp).addClass('peg-white')

setRangeIndicators = () ->
  $('.range-max-home p').text(home_comfort_max)
  $('.range-min-home p').text(home_comfort_min)
  $('.range-max-home').css
    'transform' : "rotate(" + (home_comfort_max-70)*3 + "deg)"
  $('.range-min-home').css
    'transform' : "rotate(" + (home_comfort_min-70)*3 + "deg)"

setRangeIndicatorsAway = () ->
  $('.range-max-away p').text(away_comfort_max)
  $('.range-min-away p').text(away_comfort_min)
  $('.range-max-away').css
    'transform' : "rotate(" + (away_comfort_max-70)*3 + "deg)"
  $('.range-min-away').css
    'transform' : "rotate(" + (away_comfort_min-70)*3 + "deg)"

handleOverlay = () ->
  if $('.overlay').is(':visible')
    $('.overlay').fadeOut(50)
  return


$ ->
  # generate pegs
  peg_index = [40..100]
  for i in peg_index
    $('.temp-band').append("<div class='peg' id=peg-" + i + "></div>")
    $("#peg-" + i).css
      'transform' : "rotate(" + (i-70)*3 + "deg)"

  cleanPegs()

  # set range pegs
  range_index = [40..home_comfort_min].concat([home_comfort_max..100])
  for i in range_index
    $("#peg-" + i).addClass('peg-dgray')

  # set range
  setRangeIndicators()

  $('.overlay').hover ->
    $(this).fadeOut 250, ->
      $('#press-for-menu').fadeIn()

  # adjust temp
  $('#ccw-turn').click ->
    handleOverlay()
    if timeout
      clearTimeout(timeout)
    if (mode == 'MAIN' || mode == 'ADJUSTING-TEMP')
      decreaseTemp()
      timeout = setTimeout(switchToCurrent, 1500)
      mode = 'ADJUSTING-TEMP'
      return
    else if (mode == 'HOME-MIN')
      rotateHomeMenuCCW()
      mode = 'HOME-EXIT'
      return
    else if (mode == 'HOME-EXIT')
      rotateHomeMenuCCW()
      mode = 'HOME-MAX'
      return
    else if (mode == 'HOME-MAX')
      rotateHomeMenuCCW()
      mode = 'HOME-MIN'
      return
    else if (mode == 'AWAY-MIN')
      rotateAwayMenuCCW()
      mode = 'AWAY-EXIT'
      return
    else if (mode == 'AWAY-EXIT')
      rotateAwayMenuCCW()
      mode = 'AWAY-MAX'
      return
    else if (mode == 'AWAY-MAX')
      rotateAwayMenuCCW()
      mode = 'AWAY-MIN'
      return
    else if (mode == 'MENU-EXIT')
      return
    else if (mode == 'MENU-HOME')
      elemToggle('#menu-home', '#menu-exit')
      $('.main-display').show()
      $('.home-display').hide()
      $('#press-to-adjust').hide()
      mode = 'MENU-EXIT'
      return
    else if (mode == 'MENU-AWAY')
      elemToggle('#menu-away', '#menu-home')
      $('.home-display').show()
      $('.away-display').hide()
      mode = 'MENU-HOME'
      return
    else if (mode == 'MENU-FAN')
      elemToggle('#menu-fan', '#menu-away')
      $('.away-display').show()
      $('.fan-display').hide()
      mode = 'MENU-AWAY'
      return
    else if (mode == 'HOME-MIN-ADJUST' && home_comfort_min > 40 )
      $.when(adjustRangeDown(home_comfort_min)).then ->
        home_comfort_min += -1
      return
    else if (mode == 'HOME-MAX-ADJUST' && home_comfort_max > (home_comfort_min + 1) )
      $.when(adjustRangeDown(home_comfort_max)).then ->
        home_comfort_max += -1
      return
    else if (mode == 'AWAY-MIN-ADJUST' && away_comfort_min > 40 )
      $.when(adjustRangeDownAway(away_comfort_min)).then ->
        away_comfort_min += -1
      return
    else if (mode == 'AWAY-MAX-ADJUST' && away_comfort_max > (away_comfort_min + 1) )
      $.when(adjustRangeDownAway(away_comfort_max)).then ->
        away_comfort_max += -1
      return
    else if (mode == 'FAN-AUTO')
      rotateFanMenuCCW()
      mode = 'FAN-EXIT'
      return
    else if (mode == 'FAN-EXIT')
      rotateFanMenuCCW()
      mode = 'FAN-OFF'
      return
    else if (mode == 'FAN-OFF')
      rotateFanMenuCCW()
      mode = 'FAN-ON'
      return
    else if (mode == 'FAN-ON')
      rotateFanMenuCCW()
      mode = 'FAN-AUTO'
      return

  $('#cw-turn').click ->
    handleOverlay()
    if timeout
      clearTimeout(timeout)
    if (mode == 'MAIN' || mode == 'ADJUSTING-TEMP')
      increaseTemp()
      timeout = setTimeout(switchToCurrent, 1500)
      mode = 'ADJUSTING-TEMP'
      return
    else if (mode == 'HOME-MIN')
      rotateHomeMenuCW()
      mode = 'HOME-MAX'
      return
    else if (mode == 'HOME-MAX')
      rotateHomeMenuCW()
      mode = 'HOME-EXIT'
      return
    else if (mode == 'HOME-EXIT')
      rotateHomeMenuCW()
      mode = 'HOME-MIN'
      return
    else if (mode == 'AWAY-MIN')
      rotateAwayMenuCW()
      mode = 'AWAY-MAX'
      return
    else if (mode == 'AWAY-MAX')
      rotateAwayMenuCW()
      mode = 'AWAY-EXIT'
      return
    else if (mode == 'AWAY-EXIT')
      rotateAwayMenuCW()
      mode = 'AWAY-MIN'
      return
    else if (mode == 'MENU-EXIT')
      elemToggle('#menu-exit', '#menu-home')
      $('.main-display').hide()
      $('.home-display').show()
      $('#press-to-adjust').fadeIn()
      mode = 'MENU-HOME'
      return
    else if (mode == 'MENU-HOME')
      elemToggle('#menu-home', '#menu-away')
      $('.home-display').hide()
      $('.away-display').show()
      mode = 'MENU-AWAY'
      return
    else if (mode == 'MENU-AWAY')
      elemToggle('#menu-away', '#menu-fan')
      $('.away-display').hide()
      $('.fan-display').show()
      mode = 'MENU-FAN'
      return
    else if (mode == 'MENU-FAN')
      return
    else if (mode == 'HOME-MIN-ADJUST' && home_comfort_min < (home_comfort_max - 1) )
      $.when(adjustRangeUp(home_comfort_min)).then ->
        home_comfort_min += 1
      return
    else if (mode == 'HOME-MAX-ADJUST' && home_comfort_max < 100 )
      $.when(adjustRangeUp(home_comfort_max)).then ->
        home_comfort_max += 1
      return
    else if (mode == 'AWAY-MIN-ADJUST' && away_comfort_min < (away_comfort_max - 1) )
      $.when(adjustRangeUpAway(away_comfort_min)).then ->
        away_comfort_min += 1
      return
    else if (mode == 'AWAY-MAX-ADJUST' && away_comfort_max < 100 )
      $.when(adjustRangeUpAway(away_comfort_max)).then ->
        away_comfort_max += 1
      return
    else if (mode == 'FAN-AUTO')
      rotateFanMenuCW()
      mode = 'FAN-ON'
      return
    else if (mode == 'FAN-ON')
      rotateFanMenuCW()
      mode = 'FAN-OFF'
      return
    else if (mode == 'FAN-OFF')
      rotateFanMenuCW()
      mode = 'FAN-EXIT'
      return
    else if (mode == 'FAN-EXIT')
      rotateFanMenuCW()
      mode = 'FAN-AUTO'
      return




  $('.display').click ->
    handleOverlay()
    if (mode == 'ADJUSTING-TEMP')
      switchToCurrent()
      clearTimeout(timeout)
      mode = 'MAIN'
      return
    else if (mode == 'MAIN')
      $('#press-for-menu').hide()
      revealMenu()
      mode = 'MENU-EXIT'
      return
    else if (mode == 'HOME-MIN')
      $.when(showRangeHandleHome(home_comfort_min)).then ->
        mode = 'HOME-MIN-ADJUST'
      return
    else if (mode == 'HOME-MAX')
      $.when(showRangeHandleHome(home_comfort_max)).then ->
        mode = 'HOME-MAX-ADJUST'
      return
    else if (mode == 'HOME-EXIT')
      $.when(hideHome()).then ->
        showMain()
        animateBand()
        mode = 'MAIN'
      return
    else if (mode == 'HOME-MIN-ADJUST')
      $.when(hideRangeHandleHome(home_comfort_min)).then ->
        mode = 'HOME-MIN'
    else if (mode == 'HOME-MAX-ADJUST')
      $.when(hideRangeHandleHome(home_comfort_max)).then ->
        mode = 'HOME-MAX'
      return
    else if (mode == 'AWAY-MIN')
      $.when(showRangeHandleAway(away_comfort_min)).then ->
        mode = 'AWAY-MIN-ADJUST'
      return
    else if (mode == 'AWAY-MAX')
      $.when(showRangeHandleAway(away_comfort_max)).then ->
        mode = 'AWAY-MAX-ADJUST'
      return
    else if (mode == 'AWAY-EXIT')
      $.when(hideAway()).then ->
        showMain()
        animateBand()
        mode = 'MAIN'
      return
    else if (mode == 'AWAY-MIN-ADJUST')
      $.when(hideRangeHandleAway(away_comfort_min)).then ->
        mode = 'AWAY-MIN'
    else if (mode == 'AWAY-MAX-ADJUST')
      $.when(hideRangeHandleAway(away_comfort_max)).then ->
        mode = 'AWAY-MAX'
      return
    else if (mode == 'MENU-EXIT')
      $.when(hideMenu()).then ->
        mode = 'MAIN'
      return
    else if (mode == 'MENU-HOME')
      $.when(hideMenu()).then ->
        mode = 'HOME-MIN'
      return
    else if (mode == 'MENU-AWAY')
      $.when(hideMenu()).then ->
        mode = 'AWAY-MIN'
      return
    else if (mode == 'MENU-FAN')
      $.when(hideMenu()).then ->
        showFan()
        mode = 'FAN-AUTO'
      return
    else if (mode == 'FAN-AUTO')
      $.when(switchFan('AUTO')).then ->
        $('#fan-display-icon .gray-fan').fadeIn()
        $('#fan-display-icon .black-fan').fadeOut()
        fan_mode = true
      return
    else if (mode == 'FAN-ON')
      $.when(switchFan('ON')).then ->
        $('#fan-display-icon .gray-fan').fadeIn()
        $('#fan-display-icon .black-fan').fadeOut()
        fan_mode = true
      return
    else if (mode == 'FAN-OFF')
      $.when(switchFan('OFF')).then ->
        $('#fan-display-icon .gray-fan').fadeOut()
        $('#fan-display-icon .black-fan').fadeIn()
        fan_mode = false
      return
    else if (mode == 'FAN-EXIT')
      $.when(hideFan()).then ->
        shrinkTransitionalCircle()
        showMain()
        if !fan_mode
          $('#fan-small').hide()
          $('#fan-small-black').show()
        else
          $('#fan-small').show()
          $('#fan-small-black').hide()
        mode = 'MAIN'
      return


