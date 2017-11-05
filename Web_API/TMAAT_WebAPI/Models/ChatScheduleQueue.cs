using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TMAAT_WebAPI.Models
{
    public class ChatScheduleQueue
    {
        public int id { get; set; }
        public int customerid { get; set; }
        public int csremployeeid { get; set; }
        public string customerEmail { get; set; }
        public string customerName { get; set; }
        public DateTime? time { get; set; }
        public string customertime { get; set; }
    }
}