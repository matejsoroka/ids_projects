$(function () {

    $(".__multiselect").multiSelect(); // multiselect init

    let alerts = $(".alert");          // alerts animations
    alerts.slideDown();
    setTimeout(function(){
        alerts.slideUp();
    }, 3000);

});
