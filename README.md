# TMAAT

# iOS Application

To run (macOS only)
1) open iOS_Application folder with xCode 9 IDE by Apple'
2) Select the project file, and under "General" sign with an Apple developer account
3) If you attempt to run on an iOS device and run into issues, you may need to accept the certificate in settings->general->device management
4) You can also run using xCode's built in emulators, but will not be able to test camera features

# Android Application

To run
1) Open Android_App/OnlineMovingEstimator folder with Android Studio
2) Build/run project with an Android mobile device with API 21 or higher
3) You may need to change permissions on mobile device to allow access to camera
4) Internet connection is needed in order to connect to back-end
5) Ensure that auto-rotation is ENABLED on your device

# WebRTC 

The video & text chat is currently stable on Chrome, Firefox and Safari. As WebRTC is implemented per-browser, some maintenance is required to keep up with browser updates.

A signalling server is required for coordination between peers. Our implementation utilizes Scaledrone's free tier service (https://www.scaledrone.com/) . Boilerplate code for both video and text chat is adapted from Scaledrone. The channel ID is defined on line 14 of webrtc.js; this ID is provided by Scaledrone when you create an account.

Proper discovery between peers requires both a STUN and a TURN server. These are defined in the Configuration object created on line 16 of webrtc.js. We are using Google's free public STUN server and a free TURN server from http://viagenie.ca/ .

Any unique identifier can be used to define the room name. We use the chat id from our backend implementation, but as long as both peers have a way to agree on the room name (we simply stash it in the URL), any string can be used to define the room.

# Backend

TWO MEN AND A TRUCK
Online Estimator Web API - Built with ASP.NET and C#, using a mySQL database
Documentation
________________


For TMAAT: depending on how you host the site and the api, you will most likely want to remove the CORS support we added during development.
In the web.config file:
<customHeaders>
        <add name="Access-Control-Allow-Origin" value="*" />
        <add name="Access-Control-Allow-Methods" value="GET, PUT, POST, DELETE, HEAD" />
        <add name="Access-Control-Allow-Headers" value="Origin, X-Requested-With, Content-Type, Accept, Authorization, Auth-Token" />
</customHeaders>
________________


Any request requiring Auth-Token will return 401 unauthorized on invalid credentials.


POST
/api/uploadImage?room=ROOMNAME

Content-type: multipart/form-data
Parameters: *.jpg image file
Returns: 200 OK + JSON list of recognized moving items following this model:


public class MovingItemEnum
    {
        public int id { get; set; }
        public string item { get; set; }
        public string name { get; set; }
        public string category { get; set; }
        public string generic { get; set; }
        public List<int> related { get; set; }
        public List<int> relatedInCategory { get; set; }
    }




GET
/api/getItems

Returns: 200 OK + JSON list of all moving items


GET
/api/getQueue

Returns: 200 OK + JSON list of customers waiting for chat
Requires Auth-Token header, https








POST
/api/customerJoinQueue?customerId=ID

Effects: Adds customer to waiting chat queue
Returns: 200 OK + chat ID, 304 Not Modified on failure


POST
/api/customerRegister?name=NAME&email=EMAIL

Effects: Adds customer to customer database
Returns: 200 OK + customer ID, 304 Not Modified on failure


POST
/api/csrRegister

Content-Type: application/json
With body structure:
{
        "username": "USERNAME",
        "password": "PASSWORD"
}
Effects: Adds CSR to database and allows them to login
Returns: 200 OK + chat ID, 304 Not Modified on failure
Requires: https


POST
/api/csrLogin

Content-Type: application/json
With body structure:
{
        "username": "USERNAME",
        "password": "PASSWORD"
}
Effects: Adds CSR auth token to database and gives the token authorization to protected API methods for 24 hours.
Returns: 200 OK + Auth token in response body
Requires: https




POST
/api/csrJoinQueue?username=USERNAME&chatId=ID

Effects: Adds CSR to the specified chat instance so it will no longer show up in getQueue call.
Returns: 200 OK + chat ID, 304 Not Modified on failure
Requires: Auth-Token header, https


POST
/api/customerJoinScheduleQueue?cid=ID&ctime=TIME

TIME = One of [morning, afternoon, evening]
Effects: Adds customer to waiting scheduled chat queue
Returns: 200 OK + chat ID, 304 Not Modified on failure


POST
/api/csrJoinScheduleQueue?username=USERNAME&chatid=ID&date=DATE

DATE = datetime in ISO string format
Effects: Adds CSR to the specified chat schedule instance so it will no longer show up in getScheduleQueue call, sends customer confirmation email with link to chat.
Returns: 200 OK, 304 Not Modified on failure
Requires: Auth-Token header, https


GET
/api/getScheduleQueue

Returns: 200 OK, JSON list of customers waiting for a scheduled chat
Requires Auth-Token header, https


POST
/api/removeScheduleChat?chatid=ID

Effects: Removes the specified scheduled chat from the queue
Returns: 200 OK, 304 Not Modified on failure
Requires: Auth-Token header, https


POST
/api/removeChat?chatid=ID

Effects: Removes the specified chat from the queue
Returns: 200 OK, 304 Not Modified on failure
Requires: Auth-Token header, https


GET
/api/getCsrScheduleQueue?username=USERNAME

Returns: 200 OK JSON list of customers waiting for a scheduled chat that have a specific CSR assigned to them
Requires Auth-Token header, https
