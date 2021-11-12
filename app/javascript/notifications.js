class Notifications{
   constructor(props){
     super(props)

    this.state = {
      // notifications = document.querySelectorAll("[data-behavior='notifications']")
    }

    document.getElementById('notifications')
    document.getElementById('unread-count')
    document.getElementById('notification-items')
    document.getElementById('notifications-link')
    console.log("IN NOTIF")

    // @notifications = $("[data-behavior='notifications']")
    // if (this.state.notifications.length > 0) {
    // setup()
    // }
   }

   setup(){
    // $("[data-behavior='notifications']").on('click', function1());
    // $("[data-behavior='notifications-link']").on('click', function2());
    // $("[data-behavior=''unread-count']").on('click', function3());
    // $("[data-behavior='notification-items']").on('click', function4());
    // var notificationObject = document.getElementById("notifications");
    //   notificationObject.addEventListener("click", myScript);
    // handleClick()
    //   $("[data-behavior='notifications-link']").onclick = handleClick()
    //   $.ajax(
    //     url: "/notifications.json",
    //     dataType: "JSON",
    //     method: "GET",
    //     success: handleSuccess()
    //   )
   }

   onClick(){

   }

   function1(){
    console.log("[data-behavior='notifications']")
   }

   function2(){
     console.log("notifications-link")
   }

   function3(){
    console.log("unread-count")
   }
   function4(){
    console.log("notification-items")
   }

  //  handleClick: (e) =>
  //    $.ajax(
  //      url: "/notifications/mark_as_read"
  //      dataType: "JSON"
  //      method: "POST"
  //      success: ->
  //        $("[data-behavior='unread-count']").text(0)
  //    )

  //  handleSuccess: (data) =>
  //    items = $.map data, (notification) ->
  //      "<a class='dropdown-item' href='#{notification.url}'>#{notification.actor} #{notification.action} #{notification.notifiable.type}</a>"

  //    $("[data-behavior='unread-count']").text(items.length)
  //    $("[data-behavior='notification-items']").html(items)


}