function sign_up() {
    var username = document.getElementById("email").value;
    var password = document.getElementById("psw").value;
    var repsw = document.getElementById("psw-repeat").value;
    if (password != repsw) {
        alert("Password has to match repeat password! Please try again.");
        document.getElementById('id02').style.display='block';
    }
    else{
        console.log("Logging in temp user...");
        loginRequest = new XMLHttpRequest();
        loginRequest.open("POST","https://35.9.22.105:5555/api/csrRegister",true);
        loginRequest.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        loginRequest.onload = function(e){
            console.log("user logged in");
        };
        loginRequest.send(JSON.stringify( { "username": username, "password": password}) );
        document.getElementById('id02').style.display='none';
    }
}
function sign_in(){
    var username = document.getElementById("signedname").value;
    var password = document.getElementById("signedpsw").value;
    console.log("Logging in temp user...");
    loginRequest = new XMLHttpRequest();
    loginRequest.open("POST","https://35.9.22.105:5555/api/csrLogin",true);
    loginRequest.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    loginRequest.onload = function(e){
        console.log("user logged in");
        token = loginRequest.responseText;
        console.log("token received: " + token);
        window.localStorage.removeItem("user-Token");
        window.localStorage.setItem("user-Token",loginRequest.responseText);
        if(window.localStorage.getItem("user-Token") == ""){
            alert("Wrong Username and/or Password! Please try again.");
            document.getElementById('id01').style.display='block';
        }
        else{
            window.localStorage.removeItem("username");
            window.localStorage.setItem("username",username);
            console.log(window.localStorage.getItem("user-Token"));
            console.log(window.localStorage.getItem("username"));
            document.getElementById('id01').style.display='none';
            // window.location.assign("https://cse.msu.edu/~will1907/tmaat/beta/beta_csrhome.html");
            window.location.assign("https://dtaraso.github.io/TMAAT/Web_Application/csrHome.html");
        }
    };
    loginRequest.send(JSON.stringify( { "username": username, "password": password}) );
}
