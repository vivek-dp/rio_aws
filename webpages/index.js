$(document).ready(function(){
	// window.location = 'skp:callpage@'+ 1;
	$('#page_content').load("load_wall.html");

	$(".fbutton").click(function (e) {
		$(this).addClass("active").siblings().removeClass("active");
	});

});

function hideLoad(val){
	document.getElementById("load").style.display = "none";
}

function htmlDone(){
	document.getElementById("load").style.display = "none";
	toastr.success('HTML Generated Successfully!', 'Success')
}

function passUptVal(page, key, value){
	alert(page)
	alert(key)
	alert(value)
}

function passPageToJs(page){
	$('#fname').val(page);
}

function pager(pval){
	if (pval == 1){
		$('#page_content').load("load_wall.html");
	}else if (pval == 2){
		$('#page_content').load("load_add_comp.html");
	}else if (pval == 3){
		$('#page_content').load("load_add_attr.html");
	}else if (pval == 4){
		$('#page_content').load("load_html.html");
	}
}
