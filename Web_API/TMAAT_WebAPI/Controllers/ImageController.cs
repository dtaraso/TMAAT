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

namespace TMAAT_WebAPI.Controllers
{
    [RoutePrefix("api")]
    public class ImageController : ApiController
    {
        public static string WORKING_DIR = "C:\\Users\\Kevin\\Desktop\\darknet-master\\darknet-master\\build\\darknet\\x64";
        [HttpGet]
        [Route("test")]
        public IHttpActionResult Test() {
            return Ok();
        }

        [HttpPost]
        [Route("uploadImage")]
        public async Task<HttpResponseMessage> UploadImage()
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + "/uploads/";
            // Check if the request contains multipart/form-data.
            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }
            if(!Directory.Exists(path)) {
                Directory.CreateDirectory(path);
            }
            var streamProvider = new MultipartFormDataStreamProvider(path);
            var task = await Request.Content.ReadAsMultipartAsync(streamProvider);

            var img = CopyToDarknet(streamProvider.FileData[0].LocalFileName);

            File.Delete(streamProvider.FileData[0].LocalFileName);

            var result = new HttpResponseMessage(HttpStatusCode.OK);
            result.Content = new StringContent(RunImageRecognition(img[0], img[1]));
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

        public string RunImageRecognition(string imgPath, string imgAbsPath)
        {
            var result = Run(WORKING_DIR + "\\darknet_no_gpu.exe",
                "detector test data/coco.data cfg/yolo.cfg yolo.weights " + imgPath);
            //clean up upload
            File.Delete(imgAbsPath);
            //get image

            return result;
        }

        public HttpResponseMessage HandleError(string e) {
            var err = new HttpResponseMessage(HttpStatusCode.InternalServerError);
            err.ReasonPhrase = e;
            return err;
        }

        public string[] CopyToDarknet(string startPath) {
            File.Copy(startPath, WORKING_DIR + "\\data\\upload.jpg");
            return new string[] { "data/upload.jpg", WORKING_DIR + "\\data\\upload.jpg" };
        }
    }
}