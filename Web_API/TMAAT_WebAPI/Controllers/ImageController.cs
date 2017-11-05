using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Cors;
using TMAAT_WebAPI.Models;
using TMAAT_WebAPI.Resources;

namespace TMAAT_WebAPI.Controllers
{
    [RoutePrefix("api")]
    public class ImageController : ApiController
    {
        public static string WORKING_DIR = "C:\\Users\\Administrator\\Desktop\\darknet\\x64";

        [RequireHttpsFilter]
        [HttpGet]
        [Route("authTest")]
        public IHttpActionResult AuthTest() {
            return Ok();
        }

        [HttpPost]
        [Route("uploadImage")]
        public async Task<HttpResponseMessage> UploadImage([FromUri] string room)
        {
            if(room != null) {
                room = room.ToLower().Replace(" ", "");
            }
            try {
                string path = AppDomain.CurrentDomain.BaseDirectory + "/uploads/";
                // Check if the request contains multipart/form-data.
                if (!Request.Content.IsMimeMultipartContent())
                {
                    throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
                }
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                var streamProvider = new MultipartFormDataStreamProvider(path);
                var task = await Request.Content.ReadAsMultipartAsync(streamProvider);
                var img = CopyToDarknet(streamProvider.FileData[0].LocalFileName);

                File.Delete(streamProvider.FileData[0].LocalFileName);

                var result = new HttpResponseMessage(HttpStatusCode.OK);
                result.Content = new StringContent(RunImageRecognition(img[0], img[1], room));
                return result;
            }
            catch(Exception e) {
                return HandleError(e);
            }
        }

        [HttpPost]
        [Route("uploadImageFake")]
        public HttpResponseMessage UploadImageFake()
        {
            // Check if the request contains multipart/form-data.
            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }

            //prune list
            var validItems = DBController.getItemsFromDB();
            var fakeList = new List<MovingItemEnum>();

            fakeList.Add(validItems[6]);
            fakeList.Add(validItems[8]);
            fakeList.Add(validItems[10]);
            fakeList.Add(validItems[11]);
            fakeList.Add(validItems[12]);

            var json = JsonConvert.SerializeObject(fakeList);

            var result = new HttpResponseMessage(HttpStatusCode.OK);
            result.Content = new StringContent(json);
            return result;
        }

        public static string Run(string fileName, string args)
        {
            string returnvalue = "";

            ProcessStartInfo info = new ProcessStartInfo(fileName);
            info.WorkingDirectory = WORKING_DIR;
            info.UseShellExecute = false;
            info.Arguments = args;
            info.RedirectStandardInput = true;
            info.RedirectStandardOutput = true;
            info.RedirectStandardError = true;
            info.CreateNoWindow = true;

            using (Process process = Process.Start(info))
            {
                returnvalue = process.StandardOutput.ReadToEnd();
            }

            return returnvalue += "\r\nDone.";
        }

        public string RunImageRecognition(string imgPath, string imgAbsPath, string room)
        {
            var raw = Run(WORKING_DIR + "\\darknet_no_gpu.exe",
                "detector test data/coco.data cfg/yolo.cfg yolo.weights " + imgPath);
            //clean up upload
            File.Delete(imgAbsPath);
            //get image?

            var categories = new StringReader(raw);

            //prune list
            var result = new List<MovingItemEnum>();
            var validItems = DBController.getItemsFromDB();

            //skip first line
            var current = categories.ReadLine();
            current = categories.ReadLine();
            while (current != null)
            {
                foreach (var i in validItems)
                {
                    if (kindOfMatches(i, current))
                    {
                        //change vague matches to room
                        if(i.related != null && i.related.Count > 0) {
                            foreach(var r in i.related) {
                                if (validItems[r-1].category.ToLower().Replace(" ", "") == room)
                                {
                                    result.Add(validItems[r-1]);
                                    break;
                                }
                            }
                        }
                        else {
                            if (i.category.ToLower().Replace(" ", "") == room)
                            {
                                result.Add(i);
                                break;
                            }
                        }
                        break;
                    }
                }
                current = categories.ReadLine();
            }

            var json = JsonConvert.SerializeObject(result);

            return json;
        }

        public HttpResponseMessage HandleError(Exception e) {
            var err = new HttpResponseMessage(HttpStatusCode.InternalServerError);
            err.ReasonPhrase = e.Message.Replace("\n", "").Replace("\r", "");
            return err;
        }

        public string[] CopyToDarknet(string startPath) {
            File.Copy(startPath, WORKING_DIR + "\\data\\upload.jpg");
            return new string[] { "data/upload.jpg", WORKING_DIR + "\\data\\upload.jpg" };
        }

        private bool kindOfMatches(MovingItemEnum mie, string cur) {
            //format/check result name
            var colonIndex = cur.IndexOf(':');
            if(colonIndex == -1) {
                return false;
            }
            var curLower = cur.Substring(0, colonIndex).ToLower();
            if(curLower == mie.generic) {
                return true;
            }
            return false;
        }
    }
}