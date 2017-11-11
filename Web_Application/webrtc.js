var searchParams = new URLSearchParams(window.location.search);
//console.log("name: " + searchParams.get("n"));
name = searchParams.get("n");

const roomHash = location.hash.substring(1);
const drone = new ScaleDrone('GZtLCKtcestPU9LF');
const roomName = 'observable-' + roomHash;
const configuration = {
    iceServers: [
        {urls: 'stun:stun.l.google.com:19302'},
        {urls: 'turn:numb.viagenie.ca',credential: 'muazkh', username: 'webrtc@live.com'}]
};

var room, pc, dataChannel;

drone.on('open', function(){
    room = drone.subscribe(roomName);
    room.on('members', function(members) {
        //console.log("members: " + members);
        const isOfferer = (members.length === 2);
        startWebRTC(isOfferer);
    });
});

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

    // If user is offerer let the 'negotiationneeded' event create the offer
    if (isOfferer) {
        pc.onnegotiationneeded = function(){
            pc.createOffer().then(localDescCreated).catch();
            dataChannel = pc.createDataChannel('chat');
            setupDataChannel();
        }
    }else {
        // If user is not the offerer, wait for a data channel
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
                // When receiving an offer lets answer it
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
        //insertMessageToDOM({content: '\nYou can now text chat between the two tabs!'});
        //insertMessageToDOM({content: '\n-------------------------------------------'});
    }
}

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