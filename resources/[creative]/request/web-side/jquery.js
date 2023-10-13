window.addEventListener("message",function(event){
	switch (event["data"]["Action"]){
		case "Open":
			if ($(".request-area").css("display") === "none"){
				$(".request-area").css("display","block");
				$(".request-area").animate({opacity: 1}, 500);
			}

			$(".message").html(event["data"]["Message"]);
		break;

		case "Close":
			if ($(".request-area").css("display") === "block"){
				$(".request-area").css("display","none");
			}
		break;

		case "Y":
			if ($(".request-area").css("display") === "block"){
				$(".request-area").css("display","none");
			}

			$.post("http://Request/Sucess");
		break;

		case "U":
			if ($(".request-area").css("display") === "block"){
				$(".request-area").css("display","none");
			}

			$.post("http://Request/Failure");
		break;
	}
});