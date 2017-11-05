function getURLParameter(name) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) || [null, ''])[1].replace(/\+/g, '%20')) || null;
}

function goToAddSchedule(){
    console.log("GoToSChedule");
    var cid = getURLParameter('cid');
    location.href = "addSchedule.html?cid=" + cid;
}

function goToMobileApp(){
    console.log("GoToMobileApp");
    var estimateid = getURLParameter('estimateid');
    location.href = "https://cse.msu.edu/~yeliyang/TMAAT/mobileappdownload.html?estimateid=" +estimateid;
}

function goToLiveChat(){
    console.log("GoToLiveChat");
    location.href = "https://cse.msu.edu/~will1907/tmaat/beta/betaprechat.html"
}

window.onload = function (){
    document.getElementById("myBtn").innerHTML = '';
    document.getElementById("myBtn").innerHTML += 'Your Estimate ID is: ';
    document.getElementById("myBtn").innerHTML += getURLParameter('estimateid'); //estimate ID
};

$(document).ready(function() {

    $( "#register" ).click(function() {
        //console.log($("#firstName").val())
        var name = $("#firstName").val();
        var email = $("#emailAddress").val();
        var estimateID = $("#estimateID").val();

        $.ajax({

            url: "https://35.9.22.105:5555/api/customerRegister?name=" + name + "&email=" + email,
            type: "POST",
            success: function( result ) {
                console.log("hey");
                console.log(result);
                location.href = "customerLauncher.html?cid=" + result + "&estimateid=" + estimateID;
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
                if (result != undefined){
                    location.href = "scheduleConfirmation.html"
                }
                else{
                    location.href = "scheduleNotConfirmed.html"
                }



            },
            error: function(xhr, status, error) {
                console.log("ho");
                console.log(error);
            }

        });

    });



});

