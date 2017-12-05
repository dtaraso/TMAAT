WebRTC README

The video & text chat is currently stable on Chrome, Firefox and Safari. As WebRTC is implemented per-browser, some maintenance is required to keep up with browser updates.

A signalling server is required for coordination between peers. Our implementation utilizes Scaledrone's free tier service (https://www.scaledrone.com/) . Boilerplate code for both video and text chat is adapted from Scaledrone. The channel ID is defined on line 14 of webrtc.js; this ID is provided by Scaledrone when you create an account.

Proper discovery between peers requires both a STUN and a TURN server. These are defined in the Configuration object created on line 16 of webrtc.js. We are using Google's free public STUN server and a free TURN server from http://viagenie.ca/ .

Any unique identifier can be used to define the room name. We use the chat id from our backend implementation, but as long as both peers have a way to agree on the room name (we simply stash it in the URL), any string can be used to define the room.