$(document).ready(function(){
	$(".allownumeric").keypress(function (e) {
		if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
      //alert('Numbers only allowed!')
      $.growl.error({ message: "Numbers only allowed!" });
      return false;
    }
  });
});

function OnCancel(){
	sketchup.clickcancel(1);
}

function checkd(){
	var checkDo = document.getElementById("checkdoor");
	var dropDoo = document.getElementById("doorblock");
	if (checkDo.checked == true){
		dropDoo.style.display = "block"
	}else{
		dropDoo.style.display = "none"
	}
}

function checkheight(dheight){
	var wh = document.getElementById("wheight").value;
	if (parseInt(dheight) >= parseInt(wh)){
		$.growl.error({ message: "Door height should be less than wall height!" });
		document.getElementById("door_height").value = "";
		document.getElementById("door_height").focus();
		return false;
	}
}

function SubmitVal(){
	var array = [];
	var json = {};
	var ids = new Array ("wall1", "wall2", "wheight", "wthick")
	var idval = ["Wall 1", "Wall 2", "Wall Height", "Wall Thickness"]
	for (i in ids){
		var inval = document.getElementById(ids[i]).value;
		if (inval == ""){
			$.growl.error({ message: idval[i]+" can't be empty!" });
			document.getElementById(ids[i]).focus();
			return false;
		}else {
			json[ids[i]] = inval
		}
	}
	
	var door_check = document.getElementById("checkdoor");
	if (door_check.checked == true){
		var doorids = new Array ("door_view", "door_position", "door_height", "door_length")
		var doorval = ["Door View", "Door Position", "Door Height", "Door Length"]
		var json1 = {};
		for (j in doorids){
			var getval = document.getElementById(doorids[j]).value;
			if (getval != 0 && getval != ""){
				json1[doorids[j]] = getval
			} else {
				$.growl.error({ message: doorval[j]+" can't be empty!" });
				document.getElementById(doorids[j]).focus();
				return false;
			}



			// if (doorids[j] == "door_view"){
			// 	if (getval == 0){
			// 		$.growl.error({ message: "Door view can't be blank!" });
			// 		return false;
			// 	}else{
			// 		json1[doorids[j]] = getval
			// 	}
			// }else{
			// 	json1[doorids[j]] = getval
			// }
		}
		var j1 = JSON.stringify(json1)
		json["door"] = json1
	}

	// var wh = document.getElementById("wheight").value;
	// var dh = document.getElementById("door_height").value;
	// if (dh > wh){
	// 	// var str = JSON.stringify(json);
	// 	// sketchup.submitval(str)
	// 	$.growl.error({ message: "Door height should be less than wall height!" });
	// 	return false;
	// }else{
	var str = JSON.stringify(json);
	// 	$.growl.success({ message: str });
	sketchup.submitval(str)
	// }
}
