const chatURL = "https://cse.msu.edu/~will1907/tmaat/chat/chat.html";
const appointmentURL = "https://dtaraso.github.io/TMAAT/Web_Application/CSR_confirm_appointment";

window.onload = function(){
    //console.log("token from local: " + window.localStorage.getItem("user-Token"));
    //console.log("csr name from local: " + window.localStorage.getItem("username"));

    username = window.localStorage.getItem("username");
    token = window.localStorage.getItem("user-Token");

    document.getElementById('csr_name').innerHTML = "<img src=\"images/moNX8nz0.jpg\" alt=\"Person\" width=\"96\" height=\"96\">"+"Logged in as " + username;
    startUpdates();
};

function startUpdates() {
    setInterval("updateQueues();",1000);
}

function updateQueues() {
    updateChatQueue();
    updateAppointmentQueue();
    updateScheduleQueue();
}

function updateChatQueue(){
    //console.log("Requesting chat queue from server...");
    queueRequest = new XMLHttpRequest();
    queueRequest.open("GET","https://35.9.22.105:5555/api/getQueue",true);
    queueRequest.setRequestHeader("Auth-Token", token);
    queueRequest.onload = function(){
        //console.log("Queue updated.");
        //console.log(queueRequest.response);
        queue = JSON.parse(queueRequest.response);

        htmlString = "<h2>Chat Queue</h2>";

        for (i=0 ; i<queue.length ; i++){
            customerID = queue[i].customerid;
            customerName = queue[i].customerName;
            chatID = queue[i].id;
            //chatURLstub = "betachat.html?n=CSR#"+ customerID;

            //console.log(customerName + " : " + customerID);
            //console.log(chatURLstub);

            htmlString += '<br><a href=' + chatURL + '?n=' + username + '#' + customerID + ' target="_blank" onclick="joinChat('+chatID+');">'+ customerName +'</a>';
        }

        document.getElementById('chatqueue').innerHTML = htmlString;
    };
    queueRequest.send();
}

function updateAppointmentQueue(){
    //console.log("Requesting appointment queue from server...");
    appointmentQueueRequest = new XMLHttpRequest();
    appointmentQueueRequest.open("GET","https://35.9.22.105:5555/api/getCsrScheduleQueue?username=" + username,true);
    appointmentQueueRequest.setRequestHeader("Auth-Token", token);
    appointmentQueueRequest.onload = function(){
        //console.log("appointment queue updating.");
        console.log("appointment queue response: " + appointmentQueueRequest.response);
        appointmentQueue = JSON.parse(appointmentQueueRequest.response);

        htmlString = "<h2>My Appointments</h2>";

        for (i=0 ; i<appointmentQueue.length ; i++){
            time = appointmentQueue[i].time;
            customerName = appointmentQueue[i].customerName;
            chatID = appointmentQueue[i].id;
            htmlString += '<br><a href=' + chatURL + '?n=' + username + '#' + chatID + ' target="_blank" onclick="joinChat('+chatID+');">'+ customerName + ' ' + time + '</a>';
        }

        document.getElementById('appts').innerHTML = htmlString;
    };
    appointmentQueueRequest.send();
}

function updateScheduleQueue(){
    //console.log("Requesting schedule queue from server...");
    scheduleQueueRequest = new XMLHttpRequest();
    scheduleQueueRequest.open("GET","https://35.9.22.105:5555/api/getScheduleQueue",true);
    scheduleQueueRequest.setRequestHeader("Auth-Token", token);
    scheduleQueueRequest.onload = function(){
        //console.log("schedule queue updating.");
        //console.log(scheduleQueueRequest.response);
        scheduleQueue = JSON.parse(scheduleQueueRequest.response);

        htmlString = "<h2>Appointment Requests</h2>";

        for (i=0 ; i<scheduleQueue.length ; i++){
            scheduleID = scheduleQueue[i].id;
            timeOfDay = scheduleQueue[i].customertime;
            customerName =  scheduleQueue[i].customerName;
            //htmlString += '<br>ID:' + scheduleID + '|Time:' + timeOfDay + '|CSR:' + username + '|Customer:' + customerName;
            // csr username, the chat schedule id, and the time of day that they specified.
            linkString = timeOfDay + " with " + customerName;
            htmlString += '<br><a href=' + appointmentURL + '?i=' + scheduleID + '&t=' + timeOfDay + '&n=' + username + '>' + linkString + '</a>';
        }

        document.getElementById('requests').innerHTML = htmlString;
    };
    scheduleQueueRequest.send();
}

function joinChat(chatID){
    //console.log("joinChat was called with value " + chatID);
    //console.log("CSR " + username + " joining chat " + chatID);

    joinRequest = new XMLHttpRequest();
    joinRequest.open("POST","https://35.9.22.105:5555/api/csrJoinQueue?username=" + username + "&chatId=" + chatID,true);
    joinRequest.setRequestHeader("Auth-Token", token);
    joinRequest.onload = function(){
        //console.log("Chat joined.");
    };
    joinRequest.send();
}