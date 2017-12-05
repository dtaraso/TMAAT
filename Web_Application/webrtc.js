// see README for details on signaling, STUN and TURN servers.

// Retrieve passed variables from URL:
var searchParams = new URLSearchParams(window.location.search);
name = searchParams.get("n");
email = searchParams.get("e");
chatID = searchParams.get("id");

// Define constants:
const kickbackTime = 3; //< time in minutes before we redirect the user to the scheduling page
const kickbackURL = 'https://dtaraso.github.io/TMAAT/Web_Application/customerLauncher.html';

const roomHash = location.hash.substring(1);
const drone = new ScaleDrone('GZtLCKtcestPU9LF');
const roomName = 'observable-' + roomHash;
const configuration = {
    iceServers: [
        {urls: 'stun:stun.l.google.com:19302'},
        {urls: 'turn:numb.viagenie.ca',credential: 'turn1415', username: 'bjameswilliams@gmail.com'},
        {urls: 'turn:numb.viagenie.ca',credential: 'muazkh', username: 'webrtc@live.com'}]
};

var room, pc, dataChannel, isOfferer;
var kickbackFlag = true;

window.onload = function(){
    var timer = kickbackTime * 60 * 1000;
    setInterval("kickback();",timer);
};

// Remove chat from queue when window is closed:
window.onunload = function(){
    removeChatRequest = new XMLHttpRequest();
    removeChatRequest.open("POST","https://35.9.22.105:5555/api/removeChat?chatid=" + chatID,true);
    removeChatRequest.send();
};

// Subscribe to room and define whether the user is the offerer (i.e. second connected peer):
drone.on('open', function(){
    room = drone.subscribe(roomName);
    room.on('members', function(members) {
        const isOfferer = (members.length === 2);
        if (isOfferer) {kickbackFlag = false;}
        startWebRTC(isOfferer);
    });
});

// Return to scheduling page:
function kickback(){
    if (kickbackFlag){
        alert("We're sorry, all of our customer service representatives are busy at the moment. Please schedule a chat for a time that is convenient for you.");
        var cid = roomHash;
        window.location.replace(kickbackURL + "?cid=" + cid + "&name=" + name + "&email=" + email);
    }
}

// Send signaling data via Scaledrone
function sendMessage(message){
    var body = {room: roomName, message};
    drone.publish(body);
}

function startWebRTC(isOfferer) {
    pc = new RTCPeerConnection(configuration);
    pc.onicecandidate = function(event){
        if (event.candidate) {
            sendMessage({'candidate': event.candidate});
        }
    };

    // If user is offerer let the 'negotiationneeded' event create the offer:
    if (isOfferer) {
        pc.onnegotiationneeded = function(){
            pc.createOffer().then(localDescCreated).catch();
            dataChannel = pc.createDataChannel('chat');
            setupDataChannel();
        }
    }else {
        // If user is not the offerer, wait for a data channel:
        pc.ondatachannel = function(event){
            dataChannel = event.channel;
            setupDataChannel();
        }
    }

    // When a remote stream arrives display it in the #remoteVideo element
    pc.onaddstream = function(event){
        remoteVideo.srcObject = event.stream;
    };

    navigator.getUserMedia = ( navigator.mediaDevices.getUserMedia ||
    navigator.webkitGetUserMedia ||
    navigator.mozGetUserMedia ||
    navigator.msGetUserMedia);

    // Collect and stream video & audio data:
    navigator.mediaDevices.getUserMedia({
        audio: true,
        video: true
    }).then(function(stream){
        // Display your local video in #localVideo element
        localVideo.srcObject = stream;
        // Add your stream to be sent to the conneting peer
        pc.addStream(stream);
    });

    // Listen to signaling data from Scaledrone
    room.on('data', function(message, client){
        // Message was sent by us
        if (client.id === drone.clientId) {
            return;
        }

        if (message.sdp) {
            // This is called after receiving an offer or answer from another peer
            pc.setRemoteDescription(new RTCSessionDescription(message.sdp), () => {
                // When receiving an offer, we answer it
                if (pc.remoteDescription.type === 'offer') {
                    pc.createAnswer().then(localDescCreated).catch();
                }
            });
        } else if (message.candidate) {
            pc.addIceCandidate(new RTCIceCandidate(message.candidate));
        }
    });
}

function localDescCreated(desc) {
    pc.setLocalDescription(
        desc,
        () => sendMessage({'sdp': pc.localDescription})
    );
}

// data channel for text chat:
function setupDataChannel() {
    checkDataChannelState();
    dataChannel.onopen = checkDataChannelState;
    dataChannel.onclose = checkDataChannelState;
    dataChannel.onmessage = event =>
        insertMessageToDOM(JSON.parse(event.data), false)
}

function checkDataChannelState() {
    console.log('WebRTC channel state is:', dataChannel.readyState);
    if (dataChannel.readyState === 'open') {
        kickbackFlag = false;
    }
}

// display text from data channel:
function insertMessageToDOM(options, isFromMe) {
    const template = document.querySelector('template[data-template="message"]');
    const nameEl = template.content.querySelector('.message__name');
    if (options.name) {
        nameEl.innerText = '\n' + options.name;
    }
    template.content.querySelector('.message__bubble').innerText = options.content;
    const clone = document.importNode(template.content, true);
    const messageEl = clone.querySelector('.message');
    if (isFromMe) {
        messageEl.classList.add('message--mine');
    } else {
        messageEl.classList.add('message--theirs');
    }

    const messagesEl = document.querySelector('.messages');
    messagesEl.appendChild(clone);

    // Scroll to bottom
    messagesEl.scrollTop = messagesEl.scrollHeight - messagesEl.clientHeight;
}

// set up text input:
const form = document.querySelector('form');
form.addEventListener('submit', () => {
    const input = document.querySelector('input[type="text"]');
    const value = input.value;
    input.value = '';

    const data = {
        name,
        content: value
    };

    dataChannel.send(JSON.stringify(data));

    insertMessageToDOM(data, true);
});

if (!isOfferer){
    var holdMessage = "Thanks for choosing TWO MEN AND A TRUCK!" +
            "\n\nPlease stand by for the next available customer service representative." +
            "\n\nIf no one is available to take your call in the next 3 minutes, you will be automatically forwarded to our chat scheduling system.";
    insertMessageToDOM({content: holdMessage});
}