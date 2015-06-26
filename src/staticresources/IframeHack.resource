<html>
	<head>
			
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
	<link href="/resource/1333717947000/lightbox/res/css/lightbox.css" rel="stylesheet" type="text/css" />

	<script src="../../soap/ajax/24.0/connection.js" type="text/javascript"></script>
	
	</head>

	<body onload="DoomDoom();">

	<script>
   	
	/*
		function queryFailed(error, source) {
			console.log ("An error has occurred: " + error);
		}

		function layoutResults(queryResult, source) {
			if (queryResult.size > 0) {
				var output = "";

				//get the records array 
			
				var records = queryResult.getArray('records');

				//loop through the records and construct html string 
			
				for (var i = 0; i < records.length; i++) {
					var opportunity = records[i];
					console.log(opportunity);
					//output += account.Id + " " + account.Name +	" [Industry - " + account.Industry + "]<br>";
			  }

			//render the generated html string 

			}
		}
	
	*/
	
		function DoomDoom(){
		
		// parse query string
		var qsParm = new Array();
		var query = window.location.search.substring(1);
		var parms = query.split('&');
		for (var i=0; i<parms.length; i++) {
			var pos = parms[i].indexOf('=');
				if (pos > 0) {
					var key = parms[i].substring(0,pos);
					var val = parms[i].substring(pos+1);
					qsParm[key] = val;
				}
			}
			var resourseId = qsParm['resourseId'];;
			var oppId = qsParm['oppId'];

			document.getElementById("PopUpMessage").src ="https://na11.salesforce.com/apex/OpportunityPopupInframe?Id="+oppId;
			
			console.log(' resourseId - '+resourseId+' oppId - '+oppId);
			
			
			/*
			var __sfdcSessionId = sessionId;
			console.log("__sfdcSessionId = "+__sfdcSessionId);
			
			sforce.connection.query( "Select Id, Name From Opportunity WHERE Id = "+oppId, {	
				onSuccess : layoutResults,
				onFailure : queryFailed,
					source : {
                        output : document.getElementById("output"),
                        startTime : new Date().getTime()
                    }
            });
			*/
		
		
			var overlay = $('.b-overlay');
			var lightbox = $('.b-lightbox');
			var msglightbox = $('#msglightbox');	
			var closelightbox = $('.b-lightbox .b-close-btn, a.m-closelightbox');
			
			function showOverlay() {
				overlay
					.height( $(document).height() )
					.css('opacity','0.35')
					.fadeIn('fast');
			}
			
				
			closelightbox.click( function() {
				lightbox.fadeOut('fast');			
				overlay.fadeOut('fast');
			});
		
			showOverlay();
			msglightbox.fadeIn('fast');		
		
			jQuery('body', parent.parent.document).append(jQuery("#needFiles"));
			jQuery('body', parent.parent.document).append(overlay);
			jQuery('body', parent.parent.document).append(msglightbox);

		}

	</script>
	
		<div class="b-overlay" style="display:none"></div>
		<div class="b-lightbox" id="msglightbox" style="display:none">
			<div class="b-title-bar">
				<div class="b-title">Title</div>
				<div class="b-close-btn"><a href="javascript:void(0)">Close</a></div>
			</div>
			<div class="b-content">
			<iframe id="PopUpMessage" src="" width="200" height="80" frameborder="0"></iframe>
			
			<!-- <p> MESSAGE </p>
				<p><a href="#" class="b-btn m-closelightbox">Ok</a> <a href="#" class="b-btn m-closelightbox">Cancel</a></p> -->
			</div>
		</div>    

		<div id="needFiles">
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
			<link href="/resource/1333717947000/lightbox/res/css/lightbox.css" rel="stylesheet" type="text/css" />
		</div>
		

	</body>

</html>