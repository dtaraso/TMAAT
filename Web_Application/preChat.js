const chatURL = "https://cse.msu.edu/~will1907/tmaat/chat/chat.html";
var searchParams = new URLSearchParams(window.location.search);

//console.log("found in URL:");
//console.log("name: " + searchParams.get("n"));
//console.log("email: " + searchParams.get("e"));

name = searchParams.get("n");
email = searchParams.get("e");

if (name == 'null'){
    name = prompt("Please Enter Name:", "Guest");
    email = prompt("Email Address:", "user@mail.com");
}

//console.log("Saved variables:");
//console.log("name: " + name);
//console.log("email: " + email);

// add the user to the customer database & retrieve customer ID:
//console.log("Adding user " + name + " to database");
addRequest = new XMLHttpRequest();
addRequest.open("POST","https://35.9.22.105:5555/api/customerRegister?name=" + name + "&email=" + email, true);
addRequest.onload = function(){
    customerID = addRequest.response;
    //console.log("User added: " + name + " : Customer ID " + customerID);

    // add user to request queue:
    //console.log("Adding user to chat queue ...");
    addQueueRequest = new XMLHttpRequest();
    addQueueRequest.open("POST","https://35.9.22.105:5555/api/customerJoinQueue?customerId=" + customerID,true);
    addQueueRequest.onload = function(){
        //console.log("Customer ID " + customerID + " added to chat queue.");

        // forward user on to the chat page:
        window.location.replace(chatURL + "?n=" + name + "#" + customerID);
    };
    addQueueRequest.send();
};
addRequest.send();
