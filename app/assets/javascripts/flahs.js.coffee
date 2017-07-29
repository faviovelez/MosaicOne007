$ ->
  $(".notice").on("click", (event)->
    $(event.target).hide("slow")
  )

$ ->
  $(".alert").on("click", (event)->
    $(event.target).hide("slow")
  )
