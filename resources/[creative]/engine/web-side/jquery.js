/* ----------EVENTLISTENER---------- */
$(document).ready(function(){
	window.addEventListener("message",function(event){
		if (event["data"]["show"] !== undefined){
			if (event["data"]["show"] == true){
				$(".title").html(event["data"]["title"]);
				$(".legends").html(event["data"]["legends"]);
				$("#fuelMenu").css("background",event["data"]["background"]);
				$("#fuelMenu").css("display","block");
			}

			if (event["data"]["show"] == false){
				$("#fuelMenu").css("display","none");
			}
		}

		if (event["data"]["tank"] !== undefined){
			$("#lts").html(event["data"]["lts"] + " ¢");
			$("#tank").html(event["data"]["tank"] + " %");
			$("#price").html("$" + event["data"]["price"]);
		}
	});
});