var prefix 
$(function () {
    function display(bool,type) {
       if(bool){
            $("#"+type).show();
            if (type == 'ambulance'){
                prefix = 'amb-';
            }
            if (type == 'politie' || type == 'police'){
                prefix = 'pol-';
            }
        }else{
            prefix = null;
            $("#politie").hide();
            $("#ambulance").hide();
        }
    }
    function activeer(kleur){
        if (kleur["blauw"] && kleur["blauw"] != null){
            if(!$("#"+prefix+"blauw").hasClass("blauw")){
                
                $("#"+prefix+"blauw").addClass("blauw");
            }
        }else{
            $("#"+prefix+"blauw").removeClass("blauw"); 
        }
        if (kleur["stopachter"] && kleur["stopachter"] != null){
            if(!$("#"+prefix+"stopachter").hasClass("stopachter")){
                $("#"+prefix+"stopachter").addClass("stopachter");
            }
        }else{
            $("#"+prefix+"stopachter").removeClass("stopachter"); 
        }
        if (kleur["volgachter"] && kleur["volgachter"] != null){
            
            if(!$("#"+prefix+"volgachter").hasClass("volgachter")){
                $("#"+prefix+"volgachter").addClass("volgachter");
                
            }
        }else{
            $("#"+prefix+"volgachter").removeClass("volgachter"); 
        }
        if (kleur["stopvoor"] && kleur["stopvoor"] != null){
            if(!$("#"+prefix+"stopvoor").hasClass("stopvoor")){
                $("#"+prefix+"stopvoor").addClass("stopvoor");
            }
        }else{
            $("#"+prefix+"stopvoor").removeClass("stopvoor"); 
        }
        if (kleur["groen"] && kleur["groen"] != null){
			
			if(prefix == "anwb-"){
			if(!$("#"+prefix+"groen").hasClass("stopachter")){
                $("#"+prefix+"groen").addClass("stopachter");
            }
			}else{
            if(!$("#"+prefix+"groen").hasClass("groen")){
                $("#"+prefix+"groen").addClass("groen");
            }
			}
        }else{
            $("#"+prefix+"groen").removeClass("groen"); 
			$("#"+prefix+"groen").removeClass("stopachter"); 
        }
        if (kleur["oranje"] && kleur["oranje"] != null){
            if(!$("#"+prefix+"oranje").hasClass("oranje")){
                $("#"+prefix+"oranje").addClass("oranje");
            }
        }else{
            $("#"+prefix+"oranje").removeClass("oranje"); 
        }
        if (kleur["werk"] && kleur["werk"] != null){
            if(!$("#"+prefix+"werk").hasClass("werk")){
                $("#"+prefix+"werk").addClass("werk");
            }
        }else{
            $("#"+prefix+"werk").removeClass("werk"); 
        }
        if (kleur["sirene"] && kleur["sirene"] != null){
            if(!$("#"+prefix+"sirene").hasClass("sirene")){
                $("#"+prefix+"sirene").addClass("sirene");
            }
        }else{
            $("#"+prefix+"sirene").removeClass("sirene"); 
        }
    }   

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type == "ui") {
            if (item.status == true) {
                display(true,item.scherm)
            } else {
                display(false,item.scherm)
            }
        }
        if (item.kleur != null) {
            activeer(item.kleur)
        }
    })
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('https://qb-els/exit', JSON.stringify({}));
            return false;
        }
    };
    $("#amb-close").click(function () {
        $.post('https://qb-els/exit', JSON.stringify({}));
        return false;
    })
    var i = 0
    $("#amb-blauw").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#amb-blauw").val(),
        }));
        return false;
    })
    $("#amb-groen").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#amb-groen").val(),
        }));
        return false;
    })
    $("#amb-werk").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#amb-werk").val(),
        }));
        return false;
    })
    $("#amb-oranje").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#amb-oranje").val(),
        }));
        return false;
    })
    $("#amb-sirene").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#amb-sirene").val(),
        }));
        return false;
    })
    $("#pol-close").click(function () {
        $.post('https://qb-els/exit', JSON.stringify({}));
        return false;
    })
    var i = 0
    $("#pol-blauw").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#pol-blauw").val(),
        }));
        return false;
    })
    $("#pol-groen").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#pol-groen").val(),
        }));
        return false;
    })
    $("#pol-stopvoor").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#pol-stopvoor").val(),
        }));
        return false;
    })
    $("#pol-stopachter").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#pol-stopachter").val(),
        }));
        return false;
    })
    $("#pol-werk").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#pol-werk").val(),
        }));
        return false;
    })
    $("#pol-volgachter").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#pol-volgachter").val(),
        }));
        return false;
    })
    $("#pol-oranje").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#pol-oranje").val(),
        }));
        return false;
    })
    $("#pol-sirene").click(function () {
        $.post('https://qb-els/toggle', JSON.stringify({
            value: $("#pol-sirene").val(),
        }));
        return false;
    })

    $("#submit").click(function () {
        let inputValue = $("#input").val()
        if (inputValue.length >= 100) {
            $.post("https://qb-els/error", JSON.stringify({
                error: "Input was greater than 100"
            }))
            return false;
        } else if (!inputValue) {
            $.post("https://qb-els/error", JSON.stringify({
                error: "There was no value in the input field"
            }))
            return false;
        }
        $.post('https://qb-els/main', JSON.stringify({
            text: inputValue,
        }));
        return false;;
    })
})