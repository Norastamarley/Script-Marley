(function(){

	
window.onData = function(data){

			if (data.action == "put") {

				$('#block1').show();
			}

			if (data.action == "remove"){

				$('#block1').hide();
			}

	}
	

window.onload = function(e){ window.addEventListener('message', function(event){ onData(event.data) }); }



		
		



	  

})()