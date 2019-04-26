$(function () {

    $(".__multiselect").multiSelect(); // multiselect init
	
	$( "#datepicker" ).datepicker({	   // datepicker init 
		dateFormat: "yy/mm/dd"
	});
	
    let alerts = $(".alert");          // alerts animations
    alerts.slideDown();
    setTimeout(function(){
        alerts.slideUp();
    }, 3000);

});

/*Delete button - Alert function*/
$(document).ready(function(){
	$(".btn-danger").click(function(){
		if (!confirm("Opravdu chcete vykonat akci?")) {
			event.preventDefault();
		}
	});
});
