function LoadFuction(){
	var val = 1;
	window.location = 'skp:loadingpage@'+ val;
}

$htmlArray = []
$labname = []
function showDynamicValue(vals, name, pro){
	var subval = "";
	var input = '<div class="text-danger" style="text-align:center;text-transform: capitalize;font-weight:bold;"><span>Component Name:&nbsp;</span>'+name+'</div>'
	subval += input
	for (var i = 0; i < vals.length; i++){
		spval = vals[i].split("/")
		lname = spval[0].replace(/_/g, " ");
		$labname.push(lname)
		$htmlArray.push(spval[0])
		if (spval[1].indexOf("&") == 0){
			if (spval[0].indexOf("lenx") == 0 || spval[0].indexOf("leny") == 0 || spval[0].indexOf("lenz") == 0){
				var splitv = spval[1].split("&")
				var optionlist = "";
				for (var l = 0; l < splitv.length; l++){
					if (splitv[l] != ""){
						var lastsplit = splitv[l].split("=")
						optionlist += '<option value="'+lastsplit[0]+'">'+parseFloat(lastsplit[0]).toFixed(2)+'</option>'
					}
				}
			}else{
				var splitv = spval[1].split("&")
				var optionlist = "";
				for (var o = 0; o < splitv.length; o++){
					if (splitv[o] != ""){
						var lastsplit = splitv[o].split("=")
						if (lastsplit[1] === pro[0]){
							optionlist += '<option value="'+lastsplit[0]+'" selected="selected">'+lastsplit[1]+'</option>'
						}else{
							if (parseFloat(lastsplit[1]).toFixed(2) != "NaN"){
								optionlist += '<option value="'+lastsplit[0]+'">'+parseFloat(lastsplit[1]).toFixed(2)+'</option>'
							}else{
								optionlist += '<option value="'+lastsplit[0]+'">'+lastsplit[1]+'</option>'
							}
						}
					}
				}
			}
			var input = '<div class="field"><label style="text-transform: capitalize;">'+lname+':<span style="text-transform: lowercase;"> (cm)</span></label><select id="'+spval[0]+'" class="ui fluid dropdown">'+optionlist+'</select></div>'
		}else if(spval[0] == "Lamination Code"){
			var input = '<div class="field"><label style="text-transform: capitalize;">'+lname+':<span style="text-transform: lowercase;"> (cm)</span></label><input type="text" id="'+spval[0]+'" value="'+spval[1]+'" class="form-control"></div>'
		}else{
			var input = '<div class="field"><label style="text-transform: capitalize;">'+lname+':<span style="text-transform: lowercase;"> (cm)</span></label><input type="text" id="'+spval[0]+'" value="'+parseFloat(spval[1]).toFixed(2)+'" class="form-control"></div>'
		}
		subval += input
	}
	var addsubmit = subval+'<a href="#" class="ui right floated blue button" onclick="ChangeConfig();">Apply Changes</a>'
	document.getElementById('configval').innerHTML = addsubmit;
}

function ChangeConfig(){
	var ids = $htmlArray
	var arg = [];
	for (i in ids){
		entry = document.getElementById(ids[i]).value;
		if (entry.length != 0){
			arg.push(ids[i]+"/"+entry);
		}else{
			$.growl.error({ message: $labname[i]+" can't be blank!" });
			document.getElementById(ids[i]).focus();
			return false;
		}
	}
	//window.location = 'skp:changeapply@' + arg;
}