require("jquery")

window.jQuery = $
window.$ = $


$(document).ready(function(){
	console.log("ready");
	setInterval(renderNotif, 9000)
})

function renderNotif(){
  var notifications = $('[data-behavior="notifications"]')

  //$.ajax("messages/ajaxRender")
  if(notifications.length > 0){
    var notifications_link = $('[data-behavior="notifications-link"]')
    console.log("notifications_link", notifications_link)

    $('[data-behavior="notifications"]').click(function(){
      console.log("HANDLE CLICK")
      $.ajax({
        url: "/notifications/mark_as_read",
        dataType: "JSON",
        method: "POST",
        success: function(){
          $('[data-behavior="unread-count"]').text(0)
        }
      })
    })

    $.ajax({
          url: "/notifications.json",
          datatype: "JSON",
          type: 'GET',
          success: function(result){
            console.log("DATA: ", result)
            items = $.map(result, function(notification){
              return notification.template
              //"<a class='dropdown-item' href='/"+ notification.url + "'>" + notification.actor + " " + notification.action + " in " + notification.notifiable.name + "</a><br>"
            })

            unread_count = 0
            $.each (result, function(i, notification){
              if (notification.unread){
                unread_count += 1
              }
            })

            $("[data-behavior='unread-count']").text(unread_count)
            $("[data-behavior='notification-items']").html(items)
            console.log("ITEMS", items)
            console.log("unread-count", unread_count)
          }
    })
  }

}

