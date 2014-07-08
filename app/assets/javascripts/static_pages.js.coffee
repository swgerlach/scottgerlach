# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  sections = {}
  _height = $(window).height()
  i = 0

  # Grab positions of our sections
  $(".anchor").each ->
    sections[@id] = $(this).offset().top + 5
    return

  console.log(sections)

  $(document).scroll ->
    $this = $(this)
    pos = $this.scrollTop()
    $parent = {}
    for i of sections
      $parent = $("[id=\"" + i + "\"]")

      #you now have a reference to a jQuery object that is the parent of this section
      if sections[i] > pos and sections[i] < pos + _height
        $(".subpage-nav li.active").removeClass "active"
        $('[data-target="#' + i + '"]').addClass "active"

    return

  $this = $(this)
  pos = $this.scrollTop()
  $parent = {}
  for i of sections
    $parent = $("[id=\"" + i + "\"]")

    #you now have a reference to a jQuery object that is the parent of this section
    if sections[i] > pos and sections[i] < pos + _height
      $(".subpage-nav li.active").removeClass "active"
      $('[data-target="#' + i + '"]').addClass "active"

  return

  return

jQuery ->
  $(".subpage-nav li").on 'click', ->
    $(".subpage-nav li.active").removeClass "active"
    $(this).addClass "active"

  $(".glow").on 'click', ->
    $(this).removeClass("glow")
  $(".glow").mouseover ->
    $(this).removeClass("glow")

  return


