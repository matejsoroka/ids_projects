$(function () {

    $(".__multiselect").multiSelect(); // multiselect init

    let alerts = $(".alert");          // alerts animations
    alerts.slideDown();
    setTimeout(function(){
        alerts.slideUp();
    }, 3000);

});

function  myAlert() {
    var adventure = console.log("{{ adventure[0] }}");
    if (confirm("Opravdu chcete vykonat akci?")) {
        window.location.href = "/delete-adventure/" + adventure;
    } else {
        window.location.href = "/adventures";
    }
}
