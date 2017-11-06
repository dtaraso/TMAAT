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
    location.href = "https://dtaraso.github.io/TMAAT/Web_Application/mobileappdownload.html?estimateid=" +estimateid;
}

function goToLiveChat(){
    console.log("GoToLiveChat");
    var email = getURLParameter('email');
    var name= getURLParameter('name');
    location.href = "https://cse.msu.edu/~will1907/tmaat/chat/preChat.html?" + "n=" + name + "&e=" + email;
}
function setEstimateID (){
    document.getElementById("myBtn").innerHTML = '';
    document.getElementById("myBtn").innerHTML += 'Your Estimate ID is: ';
    document.getElementById("myBtn").innerHTML += getURLParameter('estimateid'); //estimate ID
    console.log(getURLParameter('estimateid'));
};

$(document).ready(function() {

    $( "#register" ).click(function(event) {
        //console.log($("#firstName").val())
        event.preventDefault()
        var name = $("#firstName").val();
        var email = $("#emailAddress").val();
        var estimateID = $("#estimateID").val();

        $.ajax({

            url: "https://35.9.22.105:5555/api/customerRegister?name=" + name + "&email=" + email,
            type: "POST",
            success: function( result ) {
                console.log("hey");
                console.log(result);
                location.href = "customerLauncher.html?cid=" + result + "&estimateid=" + estimateID + "&name=" + name + "&email=" + email;
            },

            error: function(xhr, status, error) {
                console.log("ho");
                console.log(error);
        }
        });

    });


    $( "#scheduling > div > button" ).click(function() {
        console.log("here");
        var cid = getURLParameter('cid');

        var time = $(this).text();

        $.ajax({
            url: "https://35.9.22.105:5555//api/customerJoinScheduleQueue?cid=" + cid + "&ctime=" + time,
            type: "POST",
            success: function( result ) {
                console.log("we did it!");
                console.log(result);
                if (result != undefined){
                    //location.href = "scheduleConfirmation.html";
                    document.getElementById('schedule').style.display='none';
                    document.getElementById('overlay1').style.height = '400px';
                    document.getElementById("imgcontainer").style.marginBottom = "400px";
                    document.body.style.backgroundColor = "rgba(0,0,0,0.4)";
                }
                else{
                    //location.href = "scheduleNotConfirmed.html";
                    document.getElementById('schedule').style.display='none';
                    document.getElementById('overlay').style.height = '400px';
                    document.getElementById("imgcontainer").style.marginBottom = "400px";
                    document.body.style.backgroundColor = "rgba(0,0,0,0.4)";
                }



            },
            error: function(xhr, status, error) {
                alert("Something goes wrong here, please try again.");
            }

        });

    });



});

