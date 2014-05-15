# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->

  s = skrollr.init()

  $("a[href*=#]:not([href=#])").click ->
    if location.pathname.replace(/^\//, "") is @pathname.replace(/^\//, "") and location.hostname is @hostname
      target = $(@hash)
      target = (if target.length then target else $("[name=" + @hash.slice(1) + "]"))
      if target.length
        $("html,body").animate
          scrollTop: target.offset().top
        , 500
        false

  return



$(document).ready ->
  myDelay = ->
    m += 1
    $(".dial").val(m).trigger "change"
    window.clearInterval tmr  if m is 93
    return
  $(".dial").val(0).trigger("change").delay 200
  $(".dial").knob
    min: 0
    max: 100
    readOnly: true
    width: 120
    height: 120
    fgColor: "#ccc"
    dynamicDraw: true
    thickness: 0.2
    tickColorizeValues: true
    skin: "tron"

  tmr = self.setInterval(->
    myDelay()
    return
  , 20)
  m = 0
  return







