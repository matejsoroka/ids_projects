$(function () {

    $(".__multiselect").multiSelect(); // multiselect init

    $( "#datepicker" ).datepicker({    // datepicker init
        dateFormat: "yy/mm/dd"
    });

    let alerts = $(".alert");          // alerts animations
    alerts.slideDown();
    setTimeout(function(){
        alerts.slideUp();
    }, 3000);

});
