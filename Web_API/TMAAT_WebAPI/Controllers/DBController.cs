using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Mail;
using System.Web.Http;
using System.Web.Http.Cors;
using TMAAT_WebAPI.Models;
using TMAAT_WebAPI.Resources;

namespace TMAAT_WebAPI.Controllers
{
    [RoutePrefix("api")]
    public class DBController : ApiController
    {
        //[HttpGet]
        //[Route("setItems")]
        public HttpResponseMessage setItems()
        {
            var items = new StringReader(@"Bedroom_King Bed
Bedroom_Queen Full Bed
Bedroom_Double Twin Bed
Bedroom_Crib
Bedroom_Dresser
Bedroom_Night Stand
Living Room_Couch
Living Room_Love Seat
Living Room_Large Chair
Living Room_Coffee Table
Living Room_EndTable
Living Room_Entertainment Center
Living Room_Television
Living Room_Lamp
Dining Room_Dining Table
Dining Room_Chair
Dining Room_Buffet Table
Dining Room_China Cabinet
Kitchen_Microwave Toaster
Kitchen_TeaCart
Kitchen_Island
Office_Desk
Office_Chair
Office_Computer
Office_Monitor
Office_Bookshelf
Office_Filing Cabinet
Garage_Push Power Mower
Garage_Tool Chest
Garage_Assorted Lawn Tools
Garage_Bicycle
Patio_Chair
Patio_Swing Glider
Patio_Table
Patio_Grill Barbeque
Specialty Items_Exercise Equipment
Specialty Items_Pool Table
Specialty Items_Large Safe
Specialty Items_Kitchen Appliances
Specialty Items_Laundry Appliances
Specialty Items_Piano
Specialty Items_Hot Tub
Boxes
Business Office_Desk
Business Office_Chair
Business Office_Credenza
Business Office_Filing Cabinet
Business Office_Bookshelf
Business Office_Dresser
Business FileRoom_Filing Cabinet
Business FileRoom_Bookshelf
Business CopyRoom_Supply Cabinet
Business CopyRoom_Shelving Unit
Business ConferenceRoom_Table
Business ConferenceRoom_Chair
Business ConferenceRoom_Credenza
Business Equipment_Computer
Business Equipment_Monitor
Business Equipment_Copy Machine
Business Equipment_Printer
Business Equipment_Small Appliances
Business ReceptionArea_Desk
Business ReceptionArea_Chair
Business ReceptionArea_End Table");
            var current = items.ReadLine();
            using (var conn = new MySqlConnection("Uid = manager;" +
                                       "Pwd = rdelatable; Server = 127.0.0.1;" +
                                       "Database = tmaat_db;"))
            {
                try
                {
                    conn.Open();


                    while (current != null)
                    {
                        var index = current.IndexOf('_');
                        string cat;
                        string name;
                        if(index != -1 ) {
                            cat = current.Substring(0, index);
                            name = current.Substring(index + 1);
                            current = current.Replace(" ", "");
                        }
                        else {
                            cat = "Any";
                            name = current;
                        }
                        string sql = "INSERT INTO movingitemenum (item, name, category)" +
                        " VALUES ('" + current + "', '" + name + "', '" + cat + "'); ";
                        MySqlCommand cmd = new MySqlCommand(sql, conn);
                        var result = cmd.ExecuteNonQuery();
                        current = items.ReadLine();
                    }
                }
                catch (Exception e)
                {
                    var err = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                    err.ReasonPhrase = e.Message;
                    return err;
                }
                conn.Close();
            }
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpGet]
        [Route("getItems")]
        public HttpResponseMessage getItems() {
            List<MovingItemEnum> enumList;
            try {
                enumList = getItemsFromDB();
                var json = JsonConvert.SerializeObject(enumList);
                var result = new HttpResponseMessage(HttpStatusCode.OK);
                //result.Headers.Add("content-type", "application/json");
                result.Content = new StringContent(json);
                return result;
            }
            catch(Exception e) {
                return HandleError(e);
            }
        }

        public static List<MovingItemEnum> getItemsFromDB()
        {
            var enumList = new List<MovingItemEnum>();
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
            {
                conn.Open();
                string sql = "SELECT id, itemid, name, category, generic, related, categoryid FROM movingitemenum";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                MySqlDataReader rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    var strArr = rdr["related"].ToString().Split(',');
                    var relatedList = new List<int>();
                    foreach (string s in strArr) {
                        int i;
                        int.TryParse(s, out i);
                        if(i != 0) {
                            relatedList.Add(i);
                        }
                    }
                    enumList.Add(new MovingItemEnum
                    {
                        id = (int)rdr["id"],
                        item = (int)rdr["itemid"],
                        category = rdr["category"].ToString(),
                        name = rdr["name"].ToString(),
                        generic = rdr["generic"].ToString(),
                        related = relatedList,
                        relatedInCategory = new List<int>(),
                        categoryid = (int)rdr["categoryid"]
                    });
                }
                conn.Close();
            }
            foreach (var item in enumList)
            {
                if (item.related != null)
                {
                    foreach (int i in item.related)
                    {
                        if(i != 0) {
                            if (enumList[i - 1].category == item.category)
                            {
                                item.relatedInCategory.Add(i);
                            }
                        }
                    }
                }
            }
            return enumList;
        }

        public HttpResponseMessage HandleError(Exception e)
        {
            var err = new HttpResponseMessage(HttpStatusCode.InternalServerError);
            err.ReasonPhrase = e.Message.Replace("\n", "").Replace("\r", "");
            return err;
        }

        [RequireHttpsFilter]
        [BasicAuthFilter]
        [HttpGet]
        [Route("getQueue")]
        public HttpResponseMessage GetQueue() {
            List<ChatQueue> queue;
            try
            {
                queue = getQueueFromDB();
                var json = JsonConvert.SerializeObject(queue);
                var result = new HttpResponseMessage(HttpStatusCode.OK);
                result.Content = new StringContent(json);
                return result;
            }
            catch (Exception e)
            {
                return HandleError(e);
            }
        }

        public static List<ChatQueue> getQueueFromDB()
        {
            var queue = new List<ChatQueue>();
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
            {
                conn.Open();
                string sql = @"
SELECT chatqueue.id, chatqueue.customerid,
	customer.name, customer.email
FROM chatqueue
INNER JOIN customer ON customer.id = chatqueue.customerid
WHERE chatqueue.csremployeeid IS NULL";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                MySqlDataReader rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    queue.Add(new ChatQueue {
                        id = (int)rdr["id"],
                        customerid = (int)rdr["customerid"],
                        customerEmail = rdr["email"].ToString(),
                        customerName = rdr["name"].ToString()
                    });
                }
                conn.Close();
            }
            return queue;
        }

        [HttpPost]
        [Route("customerJoinQueue")]
        public HttpResponseMessage CustomerJoinQueue([FromUri] int customerId)
        {
            try
            {
                var id = addCustomerToDBQueue(customerId);
                if (id > 0) {
                    var response = new HttpResponseMessage(HttpStatusCode.OK);
                    response.Content = new StringContent(id.ToString());
                    return response;
                }
                return new HttpResponseMessage(HttpStatusCode.NotModified);
            }
            catch (Exception e)
            {
                return HandleError(e);
            }
        }

        public static int addCustomerToDBQueue(int cid) {
        //id if successfully added
            int id = -1;
            var changed = 0;
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
            {
                conn.Open();
                //check for valid customer
                string sql0 = "SELECT COUNT(*) FROM customer WHERE id = @cid";
                MySqlCommand cmd0 = new MySqlCommand(sql0, conn);
                cmd0.Parameters.AddWithValue("@cid", cid);
                cmd0.Prepare();
                var count0 = Convert.ToInt32(cmd0.ExecuteScalar());
                if (count0 == 0)
                {
                    conn.Close();
                    return -1;
                }

                //check for duplicates
                string sql = "SELECT COUNT(*) FROM chatqueue WHERE customerid = @cid";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cid", cid);
                cmd.Prepare();
                var count = Convert.ToInt32(cmd.ExecuteScalar());
                if(count > 0) {
                    conn.Close();
                    return -1;
                }


                string sql2 = "INSERT INTO chatqueue (customerid) VALUES ( @cid )";
                MySqlCommand cmd2 = new MySqlCommand(sql2, conn);
                cmd2.Parameters.AddWithValue("@cid", cid);
                cmd2.Prepare();
                changed = cmd2.ExecuteNonQuery();
                if(changed <= 0) {
                    return -1;
                }

                string sql3 = "SELECT id FROM chatqueue WHERE customerid = @cid";
                MySqlCommand cmd3 = new MySqlCommand(sql3, conn);
                cmd3.Parameters.AddWithValue("@cid", cid);
                cmd3.Prepare();
                MySqlDataReader rdr = cmd3.ExecuteReader();

                while (rdr.Read())
                {
                    id = (int)rdr["id"];
                }

                conn.Close();
            }
            return id;
        }

        [HttpPost]
        [Route("customerRegister")]
        public HttpResponseMessage CustomerRegister([FromUri] string name, [FromUri] string email)
        {
            try
            {
                var id = addCustomerToDB(name, email);
                if (id > 0)
                {
                    var response = new HttpResponseMessage(HttpStatusCode.OK);
                    response.Content = new StringContent(id.ToString());
                    return response;
                }
                return new HttpResponseMessage(HttpStatusCode.NotModified);
            }
            catch (Exception e)
            {
                return HandleError(e);
            }
        }

        public static int addCustomerToDB(string name, string email)
        {
            //id if successfully added or duplicate
            int id = -1;
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
            {
                conn.Open();
                //check for duplicates
                string sql = "SELECT id FROM customer WHERE email = @email";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@email", email);
                cmd.Prepare();
                var rdr0 = cmd.ExecuteReader();
                while (rdr0.Read())
                {
                    id = (int)rdr0["id"];
                }
                rdr0.Close();
                if (id >= 0) {
                    conn.Close();
                    return id;
                }

                string sql2 = "INSERT INTO customer (name, email) VALUES ( @name, @email )";
                MySqlCommand cmd2 = new MySqlCommand(sql2, conn);
                cmd2.Parameters.AddWithValue("@name", name);
                cmd2.Parameters.AddWithValue("@email", email);
                cmd2.Prepare();
                var changed = cmd2.ExecuteNonQuery();
                if(changed <= 0) {
                    conn.Close();
                    return -1;
                }

                string sql3 = "SELECT id FROM customer WHERE name = @name AND email = @email";
                MySqlCommand cmd3 = new MySqlCommand(sql3, conn);
                cmd3.Parameters.AddWithValue("@name", name);
                cmd3.Parameters.AddWithValue("@email", email);
                cmd3.Prepare();
                MySqlDataReader rdr = cmd3.ExecuteReader();

                while (rdr.Read())
                {
                    id = (int)rdr["id"];
                }
                rdr.Close();
                conn.Close();
            }
            return id;
        }

        [RequireHttpsFilter]
        [BasicAuthFilter]
        [HttpPost]
        [Route("csrJoinQueue")]
        public HttpResponseMessage csrJoinQueue([FromUri] string username, [FromUri] int chatId)
        {
            try
            {
                var id = addCSRToDBQueue(getCsrId(username), chatId);
                if (id > 0)
                {
                    var response = new HttpResponseMessage(HttpStatusCode.OK);
                    response.Content = new StringContent(id.ToString());
                    return response;
                }
                return new HttpResponseMessage(HttpStatusCode.NotModified);
            }
            catch (Exception e)
            {
                return HandleError(e);
            }
        }

        public static int addCSRToDBQueue(int csrid, int chatid)
        {
            //true if successfully added
            int id = -1;
            var changed = 0;
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
            {
                conn.Open();
                //check for valid csr
                string sql0 = "SELECT COUNT(*) FROM csremployee WHERE id = @cid";
                MySqlCommand cmd0 = new MySqlCommand(sql0, conn);
                cmd0.Parameters.AddWithValue("@cid", csrid);
                cmd0.Prepare();
                var count0 = Convert.ToInt32(cmd0.ExecuteScalar());
                if (count0 == 0)
                {
                    conn.Close();
                    return -1;
                }

                //check for valid chat
                string sql = "SELECT COUNT(*) FROM chatqueue WHERE id = @cid";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cid", chatid);
                cmd.Prepare();
                var count = Convert.ToInt32(cmd.ExecuteScalar());
                if (count != 1)
                {
                    conn.Close();
                    return -1;
                }


                string sql2 = "UPDATE chatqueue SET csremployeeid = @csrid WHERE id = @cid";
                MySqlCommand cmd2 = new MySqlCommand(sql2, conn);
                cmd2.Parameters.AddWithValue("@csrid", csrid);
                cmd2.Parameters.AddWithValue("@cid", chatid);
                cmd2.Prepare();
                changed = cmd2.ExecuteNonQuery();
                if (changed <= 0)
                {
                    return -1;
                }

                string sql3 = "SELECT id FROM chatqueue WHERE csremployeeid = @cid";
                MySqlCommand cmd3 = new MySqlCommand(sql3, conn);
                cmd3.Parameters.AddWithValue("@cid", csrid);
                cmd3.Prepare();
                MySqlDataReader rdr = cmd3.ExecuteReader();

                while (rdr.Read())
                {
                    id = (int)rdr["id"];
                }

                conn.Close();
            }
            return id;
        }
        
        [RequireHttpsFilter]
        [HttpPost]
        [Route("csrRegister")]
        public HttpResponseMessage csrRegister(CsrRegistration reg) {
            try {
                var password = reg.password;
                var name = reg.username;
                var passwordService = new PasswordService();
                string[] hashSalt = passwordService.hashPassword(password);

                using (var conn = new MySqlConnection("Uid = manager;" +
                                                       "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                       "Database = tmaat_db;"))
                {
                    conn.Open();
                    //check for duplicate usernames
                    string sql0 = "SELECT COUNT(*) FROM csremployee WHERE username = @user";
                    MySqlCommand cmd0 = new MySqlCommand(sql0, conn);
                    cmd0.Parameters.AddWithValue("@user", name);
                    cmd0.Prepare();
                    var count0 = Convert.ToInt32(cmd0.ExecuteScalar());
                    if (count0 > 0)
                    {
                        conn.Close();
                        return new HttpResponseMessage(HttpStatusCode.Conflict);
                    }

                    //create csr
                    string sql1 = "INSERT INTO csremployee (username, hash, salt) VALUES (@name, @hash, @salt)";
                    MySqlCommand cmd1 = new MySqlCommand(sql1, conn);
                    cmd1.Parameters.AddWithValue("@name", name);
                    cmd1.Parameters.AddWithValue("@hash", hashSalt[0]);
                    cmd1.Parameters.AddWithValue("@salt", hashSalt[1]);
                    cmd1.Prepare();
                    var count1 = Convert.ToInt32(cmd1.ExecuteNonQuery());
                    if (count1 != 1)
                    {
                        conn.Close();
                        return new HttpResponseMessage(HttpStatusCode.NotModified);
                    }

                    conn.Close();
                }
            }
            catch(Exception e) {
                return HandleError(e);
            }
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        public int getCsrId(string username) {
            var id = 0;
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                           "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                           "Database = tmaat_db;"))
            {
                conn.Open();
                //create csr
                string sql3 = "SELECT id FROM csremployee WHERE username = @u";
                MySqlCommand cmd3 = new MySqlCommand(sql3, conn);
                cmd3.Parameters.AddWithValue("@u", username);
                cmd3.Prepare();
                MySqlDataReader rdr = cmd3.ExecuteReader();

                while (rdr.Read())
                {
                    id = (int)rdr["id"];
                }

                conn.Close();
            }
            return id;
        }

        [RequireHttpsFilter]
        [HttpPost]
        [Route("csrLogin")]
        public HttpResponseMessage csrLogin(CsrRegistration reg)
        {
            var hash = "";
            var salt = "";
            var token = "";
            var id = 0;
            try
            {
                using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
                {
                    conn.Open();
                    //grab details from db
                    string sql0 = "SELECT * FROM csremployee WHERE username = @name";
                    MySqlCommand cmd0 = new MySqlCommand(sql0, conn);
                    cmd0.Parameters.AddWithValue("@name", reg.username);
                    cmd0.Prepare();
                    var rdr = cmd0.ExecuteReader();
                    while (rdr.Read())
                    {
                        id = (int)rdr["id"];
                        hash = rdr["hash"].ToString();
                        salt = rdr["salt"].ToString();
                    }
                    rdr.Close();
                    //check if user is in db
                    if (hash == "" || salt == "")
                    {
                        conn.Close();
                        return new System.Net.Http.HttpResponseMessage(System.Net.HttpStatusCode.Unauthorized);
                    }

                    //validate password
                    var passwordService = new PasswordService();
                    if (!passwordService.verifyPassword(reg.password, salt, hash))
                    {
                        conn.Close();
                        return new System.Net.Http.HttpResponseMessage(System.Net.HttpStatusCode.Unauthorized);
                    }
                    else
                    {
                        token = passwordService.generateToken();
                        var expiry = DateTime.Now.AddDays(1);

                        //remove existing token
                        string sql1 = "DELETE FROM csrauthtoken WHERE csremployeeid = @id";
                        MySqlCommand cmd1 = new MySqlCommand(sql1, conn);
                        cmd1.Parameters.AddWithValue("@id", id);
                        cmd1.Prepare();
                        cmd1.ExecuteNonQuery();

                        //set token
                        string sql2 = "INSERT INTO csrauthtoken (csremployeeid, token, expires) VALUES (@id, @token, @expires)";
                        MySqlCommand cmd2 = new MySqlCommand(sql2, conn);
                        cmd2.Parameters.AddWithValue("@id", id);
                        cmd2.Parameters.AddWithValue("@token", token);
                        cmd2.Parameters.AddWithValue("@expires", expiry);
                        cmd2.Prepare();
                        cmd2.ExecuteNonQuery();
                    }


                }
            }
            catch (Exception e)
            {
                return HandleError(e);
            }
            var response = new HttpResponseMessage(HttpStatusCode.OK);
            response.Content = new StringContent(token);
            return response;
        }

        [HttpGet]
        [Route("emailTest")]
        public HttpResponseMessage emailTest([FromUri] string email) {
            SmtpClient client = new SmtpClient();
            client.UseDefaultCredentials = true;
            client.Host = "smtp-mail.outlook.com";
            client.Port = 587;
            client.EnableSsl = true;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.Credentials = new NetworkCredential("tmaat_automation@outlook.com", "tmaat21mt!");
            client.Timeout = 20000;
            try {
                client.Send("tmaat_automation@outlook.com", email, "Testing Email System",
                @"Valued Customer,

This is a test.

Thank you,

TWO MEN AND A TRUCK");
            }
            catch(Exception e) {
                return HandleError(e);
            }
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        [HttpPost]
        [Route("customerJoinScheduleQueue")]
        public HttpResponseMessage CustomerJoinScheduledQueue([FromUri] int cid, [FromUri] string ctime)
        {
            try
            {
                var id = addCustomerToDBScheduleQueue(cid, ctime);
                if (id > 0)
                {
                    var response = new HttpResponseMessage(HttpStatusCode.OK);
                    response.Content = new StringContent(id.ToString());
                    return response;
                }
                return new HttpResponseMessage(HttpStatusCode.NotModified);
            }
            catch (Exception e)
            {
                return HandleError(e);
            }
        }

        public static int addCustomerToDBScheduleQueue(int cid, string customerTime)
        {
            //id if successfully added
            int id = -1;
            var changed = 0;
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
            {
                conn.Open();
                //check for valid customer
                string sql0 = "SELECT COUNT(*) FROM customer WHERE id = @cid";
                MySqlCommand cmd0 = new MySqlCommand(sql0, conn);
                cmd0.Parameters.AddWithValue("@cid", cid);
                cmd0.Prepare();
                var count0 = Convert.ToInt32(cmd0.ExecuteScalar());
                if (count0 == 0)
                {
                    conn.Close();
                    return -1;
                }

                string sql2 = "INSERT INTO chatschedulequeue (customerid, customertime) VALUES ( @cid, @ctime )";
                MySqlCommand cmd2 = new MySqlCommand(sql2, conn);
                cmd2.Parameters.AddWithValue("@cid", cid);
                cmd2.Parameters.AddWithValue("@ctime", customerTime);
                cmd2.Prepare();
                changed = cmd2.ExecuteNonQuery();
                if (changed <= 0)
                {
                    return -1;
                }

                string sql3 = "SELECT id FROM chatschedulequeue WHERE customerid = @cid";
                MySqlCommand cmd3 = new MySqlCommand(sql3, conn);
                cmd3.Parameters.AddWithValue("@cid", cid);
                cmd3.Prepare();
                MySqlDataReader rdr = cmd3.ExecuteReader();

                while (rdr.Read())
                {
                    id = (int)rdr["id"];
                }

                conn.Close();
            }
            return id;
        }

        [RequireHttpsFilter]
        [BasicAuthFilter]
        [HttpPost]
        [Route("csrJoinScheduleQueue")]
        public HttpResponseMessage csrJoinScheduleQueue([FromUri] string username, [FromUri] int chatid, [FromUri] string date)
        {
            var dateFinal = DateTime.ParseExact(date, "yyyy-MM-dd-hh:mm:ss-tt", CultureInfo.InvariantCulture);
            try
            {
                var id = addCSRToDBScheduleQueue(getCsrId(username), chatid, dateFinal);
                if (id > 0)
                {
                    sendCustomerEmail(dateFinal, username, chatid);
                    var response = new HttpResponseMessage(HttpStatusCode.OK);
                    response.Content = new StringContent(id.ToString());
                    return response;
                }
                return new HttpResponseMessage(HttpStatusCode.NotModified);
            }
            catch (Exception e)
            {
                return HandleError(e);
            }
        }

        public static int addCSRToDBScheduleQueue(int csrid, int chatid, DateTime date)
        {
            //returns chatid if successfully added
            var changed = 0;
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
            {
                conn.Open();
                //check for valid csr
                string sql0 = "SELECT COUNT(*) FROM csremployee WHERE id = @cid";
                MySqlCommand cmd0 = new MySqlCommand(sql0, conn);
                cmd0.Parameters.AddWithValue("@cid", csrid);
                cmd0.Prepare();
                var count0 = Convert.ToInt32(cmd0.ExecuteScalar());
                if (count0 == 0)
                {
                    conn.Close();
                    return -1;
                }

                //check for valid chat
                string sql = "SELECT COUNT(*) FROM chatschedulequeue WHERE id = @cid";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cid", chatid);
                cmd.Prepare();
                var count = Convert.ToInt32(cmd.ExecuteScalar());
                if (count != 1)
                {
                    conn.Close();
                    return -1;
                }


                string sql2 = "UPDATE chatschedulequeue SET csremployeeid = @csrid, time = @time WHERE id = @cid";
                MySqlCommand cmd2 = new MySqlCommand(sql2, conn);
                cmd2.Parameters.AddWithValue("@csrid", csrid);
                cmd2.Parameters.AddWithValue("@time", date);
                cmd2.Parameters.AddWithValue("@cid", chatid);
                cmd2.Prepare();
                changed = cmd2.ExecuteNonQuery();
                if (changed <= 0)
                {
                    return -1;
                }
                conn.Close();
            }
            return chatid;
        }

        [RequireHttpsFilter]
        [BasicAuthFilter]
        [HttpGet]
        [Route("getScheduleQueue")]
        public HttpResponseMessage GetScheduleQueue()
        {
            List<ChatScheduleQueue> queue;
            try
            {
                queue = getScheduleQueueFromDB();
                var json = JsonConvert.SerializeObject(queue);
                var result = new HttpResponseMessage(HttpStatusCode.OK);
                result.Content = new StringContent(json);
                return result;
            }
            catch (Exception e)
            {
                return HandleError(e);
            }
        }

        public static List<ChatScheduleQueue> getScheduleQueueFromDB()
        {
            var queue = new List<ChatScheduleQueue>();
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
            {
                conn.Open();
                string sql = @"
SELECT chatschedulequeue.id, chatschedulequeue.customerid, chatschedulequeue.time, chatschedulequeue.customertime,
	customer.name, customer.email 
FROM chatschedulequeue 
INNER JOIN customer ON customer.id = chatschedulequeue.customerid 
WHERE chatschedulequeue.csremployeeid IS NULL";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                MySqlDataReader rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    var temp = rdr["time"].ToString();
                    DateTime? dtime = null;
                    if(temp != "") {
                        dtime = DateTime.Parse(rdr["time"].ToString());
                    }
                    queue.Add(new ChatScheduleQueue
                    {
                        id = (int)rdr["id"],
                        customerid = (int)rdr["customerid"],
                        customerEmail = rdr["email"].ToString(),
                        customerName = rdr["name"].ToString(),
                        time = dtime,
                        customertime = rdr["customertime"].ToString()
                    });
                }
                conn.Close();
            }
            return queue;
        }

        [HttpPost]
        [Route("removeChat")]
        public HttpResponseMessage removeChat([FromUri] int chatid)
        {
            try
            {
                var modified = removeChatFromDB(chatid);
                if (modified > 0)
                {
                    var response = new HttpResponseMessage(HttpStatusCode.OK);
                    return response;
                }
                return new HttpResponseMessage(HttpStatusCode.NotModified);
            }
            catch (Exception e)
            {
                return HandleError(e);
            }
        }

        public static int removeChatFromDB(int chatId)
        {
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
            {
                conn.Open();
                string sql = "DELETE FROM chatqueue WHERE id = @cid";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cid", chatId);
                cmd.Prepare();
                var modified = cmd.ExecuteNonQuery();
                conn.Close();
                return modified;
            }
        }

        [RequireHttpsFilter]
        [BasicAuthFilter]
        [HttpPost]
        [Route("removeScheduleChat")]
        public HttpResponseMessage removeScheduleChat([FromUri] int chatid)
        {
            try
            {
                var modified = removeScheduleChatFromDB(chatid);
                if (modified > 0)
                {
                    var response = new HttpResponseMessage(HttpStatusCode.OK);
                    return response;
                }
                return new HttpResponseMessage(HttpStatusCode.NotModified);
            }
            catch (Exception e)
            {
                return HandleError(e);
            }
        }

        public static int removeScheduleChatFromDB(int chatId)
        {
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
            {
                conn.Open();
                string sql = "DELETE FROM chatschedulequeue WHERE id = @cid";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cid", chatId);
                cmd.Prepare();
                var modified = cmd.ExecuteNonQuery();
                conn.Close();
                return modified;
            }
        }

        [RequireHttpsFilter]
        [BasicAuthFilter]
        [HttpGet]
        [Route("getCsrScheduleQueue")]
        public HttpResponseMessage GetCsrScheduleQueue([FromUri] string username)
        {
            List<ChatScheduleQueue> queue;
            try
            {
                queue = GetCsrScheduleQueueFromDB(getCsrId(username));
                var json = JsonConvert.SerializeObject(queue);
                var result = new HttpResponseMessage(HttpStatusCode.OK);
                result.Content = new StringContent(json);
                return result;
            }
            catch (Exception e)
            {
                return HandleError(e);
            }
        }

        public static List<ChatScheduleQueue> GetCsrScheduleQueueFromDB(int csrid)
        {
            var queue = new List<ChatScheduleQueue>();
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
            {
                conn.Open();
                string sql = @"
SELECT chatschedulequeue.id, chatschedulequeue.customerid, chatschedulequeue.time, chatschedulequeue.customertime,
	customer.name, customer.email 
FROM chatschedulequeue 
INNER JOIN customer ON customer.id = chatschedulequeue.customerid 
WHERE chatschedulequeue.csremployeeid = @csrid";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@csrid", csrid);
                cmd.Prepare();
                MySqlDataReader rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    var temp = rdr["time"].ToString();
                    DateTime? dtime = null;
                    if (temp != "")
                    {
                        dtime = DateTime.Parse(rdr["time"].ToString());
                    }
                    queue.Add(new ChatScheduleQueue
                    {
                        id = (int)rdr["id"],
                        customerid = (int)rdr["customerid"],
                        customerEmail = rdr["email"].ToString(),
                        customerName = rdr["name"].ToString(),
                        time = dtime,
                        customertime = rdr["customertime"].ToString()
                    });
                }
                conn.Close();
            }
            return queue;
        }

        public void sendCustomerEmail(DateTime date, string csrName, int chatid) {
            string email = "";
            string customerName = "";
            using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
            {
                conn.Open();
                string sql = @"
SELECT chatschedulequeue.id, chatschedulequeue.customerid,
	customer.name, customer.email
FROM chatschedulequeue
INNER JOIN customer ON customer.id = chatschedulequeue.customerid
WHERE chatschedulequeue.id = @chatid";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@chatid", chatid);
                cmd.Prepare();
                MySqlDataReader rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    email = rdr["email"].ToString();
                    customerName = rdr["name"].ToString();
                }
                conn.Close();
            }

            SmtpClient client = new SmtpClient();
            client.UseDefaultCredentials = true;
            client.Host = "smtp.gmail.com";
            client.Port = 587;
            client.EnableSsl = true;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.Credentials = new NetworkCredential("tmaat.automation@gmail.com", "tmaat21mt!");
            client.Timeout = 20000;
            var msg = new MailMessage("tmaat.automation@gmail.com", email, "TMAAT Moving Estimate Scheduled",
            String.Format(@"<p>Hello {0},</p>
<p>{1} has scheduled a video chat estimate with you on {2}.</p>
<p>Use <a href='https://cse.msu.edu/~will1907/tmaat/chat/chat.html?n={0}#{3}'>this link</a> to join at that time.</p>
<p>Thank you,</p>
<p>TWO MEN AND A TRUCK</p>
<p>734.249.6072</p>", customerName, csrName, date.ToString(), chatid));
            msg.IsBodyHtml = true;
            client.Send(msg);
        }
    }
}
