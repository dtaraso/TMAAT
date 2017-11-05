$(document).ready(function() {
  var time_of_day = getURLParameter('t');
  populate_dropdown(time_of_day);
  token = window.localStorage.getItem("user-Token");

});

function getURLParameter(name) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) || [null, ''])[1].replace(/\+/g, '%20')) || null;
}

function populate_dropdown(time_of_day) {
  
  var times = {
    'Morning': ['8:00','8:30','9:00','9:30','10:00','10:30','11:00','11:30'],
    'Afternoon': ['12:00','12:30','1:00','1:30','2:00','2:30','3:00','3:30','4:00','4:30'],
    'Evening': ['5:00','5:30','6:00','6:30','7:00','7:30']
  }
  var dropdown = document.getElementById('time_confirm');
 
  for (var i = 0; i < times[time_of_day].length; i++) {
    dropdown.add(new Option(times[time_of_day][i],i));
  }

}

function cancel() {
  alert("CANCEL");
  // location.href = "https://cse.msu.edu/~will1907/tmaat/beta/beta_csrhome.html";  
  location.href = "https://dtaraso.github.io/TMAAT/Web_Application/csrHome.html";
}

function submit_post() {
  alert("SUBMIT_POST");

  var date = $('#date_confirm').val();
  var time = $('#time_confirm').find(':selected').text();
  var date_str = date+' '+time+":00";
  var datetime = new Date(date_str);

  var joinRequest = new XMLHttpRequest();
  joinRequest.open("POST","https://35.9.22.105:5555/api/csrJoinScheduleQueue?username=" + getURLParameter('n') + "&chatid=" + getURLParameter('i') + "&date="+datetime.toISOString(),true);
  joinRequest.setRequestHeader("Auth-Token", token);
  joinRequest.onload = function(){
    console.log("post worked");
    // location.href = "https://dtaraso.github.io/TMAAT/Web_Application/csrHome.html";
  };
  joinRequest.send();
}
