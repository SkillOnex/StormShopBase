var Max = 0;
var Checkpoint = 0;
// -------------------------------------------------------------------------------------------
function MinimalTimers(Seconds){
	var Seconds = parseInt(Seconds / 1000)
	var Days = Math.floor(Seconds / 86400)
	Seconds = Seconds - Days * 86400
	var Hours = Math.floor(Seconds / 3600)
	Seconds = Seconds - Hours * 3600
	var Minutes = Math.floor(Seconds / 60)
	Seconds = Seconds - Minutes * 60

	const [D,H,M,S] = [Days,Hours,Minutes,Seconds].map(s => s.toString().padStart(2,0))

	if (Days > 0){
		return D + ":" + H
	} else if (Hours > 0){
		return H + ":" + M
	} else if (Minutes > 0){
		return M + ":" + S
	} else if (Seconds > 0){
		return "00:" + S
	} else {
		return "00:00"
	}
}
// -------------------------------------------------------------------------------------------
window.addEventListener("message",function(event){
	switch (event["data"]["Action"]){
		case "Display":
			if (event["data"]["Status"]){
				if ($("#Corredor").css("display") === "none"){
					$("#Corredor").css("display","block");
					Max = event["data"]["Max"];
					Checkpoint = 1;
				}
			} else {
				if ($("#Corredor").css("display") === "block"){
					$("#Corredor").css("display","none");
				}
			}
		break;

		case "Checkpoint":
			Checkpoint = Checkpoint + 1;
		break;

		case "Ranking":
			var Result = event["data"]["Ranking"];
			if (Result !== false){
				$("#Ranking").css("display","block");

				var Position = 0;
				$("#Ranking").html("");
				$("#Ranking").html(`
					<div id="raceTitle">RANKING</div>
					<div id="raceLegend">Lista dos 15 melhores colocados neste circuito.</div>
				`);

				$("#Ranking").css("display","block");
				
				$.each(JSON.parse(Result),(k,v) => {
					$('#Ranking').append(`<div id="raceLine">
						<div class="racePosition">${Position = Position + 1}</div>
						<div class="raceName">${v["Name"]}</div>
						<div class="raceVehicle">${v["Vehicle"]}</div>
						<div class="racePoints">${MinimalTimers(v["Points"])}</div>
					</div>`);
				});

				$('#Ranking').append(`<div id="raceButtom">Pressionando a tecla <key>G</key> você fecha o ranking</div>`);
				$("#Ranking").css("display","block");
			} else {
				$("#Ranking").css("display","none");
			}
		break;

		case "Progress":
			$("#Corredor").html(`
			<div id="tempos">
				<table>
				<tbody>
				  <tr>
					<td><h1>${MinimalTimers(event["data"]["Points"])}s</h1></td>
					<td><span>TEMPO <br>PERCORRIDO</span></td>
				  </tr>
				</tbody>
			  </table>
			  <div style="clear: both"></div>
			   <img src="images/btncorrida.png"  alt=""/> 
				<table>
				<tbody>
				  <tr>
					<td><h1>${MinimalTimers(event["data"]["Timer"])}s</h1></td>
					<td><span>DURAÇÃO <br>DA CORRIDA</span></td>
				  </tr>
				</tbody>
			  </table>
			</div> 
			
			<div id="checkpoint">
				<span>CHECKPOINTS</span> <h1>${Checkpoint}/${Max}</h1><br><br>
				${event["data"]["assinatura"]  === "zulasgostoso" ? '':'<center><p><b>CRIADOR DA CORRIDA</b><br>'+event["data"]["assinatura"]+'</p></center>'}
			</div>
			
			
			<div id="melhortempo">
			  <img src="images/trofeu.png" width="90" height="90" alt=""/> 
			 <table>
				<tbody>
				  <tr>
				  ${event["data"]["melhortempo"]  === "zulasgostoso" ? '<td><h1>00:00s</h1><span>--------</span></td>':'<td><h1>'+MinimalTimers(event["data"]["melhortempo"])+'s</h1><span>'+event["data"]["name"]+'</span></td>'}
					<td><span>O MELHOR <br>TEMPO      </span></td>
				  </tr>
				</tbody>
			  </table>
			</div>
			`);
		break;
	}
});