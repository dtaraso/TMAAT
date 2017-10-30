function getURLParameter(name) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) || [null, ''])[1].replace(/\+/g, '%20')) || null;
}

function goToAddSchedule(){
    console.log("GoToSChedule");
    var cid = getURLParameter('cid');
    location.href = "addSchedule.html?cid=" + cid;
}

$(document).ready(function() {

    $( "#register" ).click(function() {
        //console.log($("#firstName").val())
        var name = $("#firstName").val();
        var email = $("#emailAddress").val();

        $.ajax({

            url: "https://35.9.22.105:5555/api/customerRegister?name=" + name + "&email=" + email,
            type: "POST",
            success: function( result ) {
                console.log("hey");
                console.log(result);
                location.href = "customerLauncher.html?cid=" + result;
            },

            error: function(xhr, status, error) {
                console.log("ho");
                console.log(error);
        }
        });

    });


    $( "#schedule > button" ).click(function() {
        var cid = getURLParameter('cid');

        var time = $(this).text();

        $.ajax({
            url: "https://35.9.22.105:5555//api/customerJoinScheduleQueue?cid=" + cid + "&ctime=" + time,
            type: "POST",
            success: function( result ) {
                console.log("we did it!")
                console.log(result);
                location.href = "scheduleConfirmation.html"
            },
            error: function(xhr, status, error) {
                console.log("ho");
                console.log(error);
            }

        });

    });



});

