using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TMAAT_WebAPI.Models
{
    public class MovingItemEnum
    {
        public int id { get; set; }
        public int item { get; set; }
        public string name { get; set; }
        public string category { get; set; }
        public string generic { get; set; }
        public List<int> related { get; set; }
        public List<int> relatedInCategory { get; set; }
        public int categoryid { get; set; }
    }
}