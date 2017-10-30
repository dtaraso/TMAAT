$(document).ready(function() {
  populate_dropdown("Morning");

});

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
  // TODO : go to live queue page
}

function submit_post() {
  // alert("SUBMIT_POST");

  var name = "Jack";
  var chatid = "1234";
  var date = $('#date_confirm').val();
  var time = $('#time_confirm').find(':selected').text();
  var date_str = date+' '+time+":00";
  var datetime = new Date(date_str);

  $.ajax({

    url: "https://35.9.22.105:5555/api/csrJoinScheduleQueue?username=" + name + "&chatid=" + +"&date="+datetime.toISOString(),type: "POST",
      success: function( result ) {
        // location.href = "customerLauncher.html?cid=" + result;
      },
      error: function(xhr, status, error) {
        console.log(error);
      }
  }); 
}
