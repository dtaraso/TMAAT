
function populate_dropdown(time_of_day) {
  
  var times = {
    'Morning': ['8','8:30','9','9:30','10','10:30','11','11:30'],
    'Afternoon': ['12','12:30','1','1:30','2','2:30','3','3:30','4','4:30'],
    'Evening': ['5','5:30','6','6:30','7','7:30']
  }
  var dropdown = document.getElementById('time_confirm');
 
  for (var i = 0; i < times[time_of_day].length; i++) {
    dropdown.add(new Option(times[time_of_day][i],i));
  }

}

function cancel() {
  alert("HERE");
  // TODO : go to live queue page
}
