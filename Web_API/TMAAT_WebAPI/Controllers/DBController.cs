using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace TMAAT_WebAPI.Controllers
{
    [RoutePrefix("api")]
    public class DBController : ApiController
    {
        [HttpGet]
        [Route("setItems")]
        public HttpResponseMessage setItems()
        {
            var items = new StringReader(@"Bedroom_KingBed
Bedroom_QueenFullBed
Bedroom_DoubleTwinBed
Bedroom_Crib
Bedroom_Dresser
Bedroom_NightStand
LivingRoom_Couch
LivingRoom_LoveSeat
LivingRoom_LargeChair
LivingRoom_CoffeeTable
LivingRoom_EndTable
LivingRoom_EntertainmentCenter
LivingRoom_Television
LivingRoom_Lamp
DiningRoom_DiningTable
DiningRoom_Chair
DiningRoom_BuffetTable
DiningRoom_ChinaCabinet
Kitchen_MicrowaveToaster
Kitchen_TeaCart
Kitchen_Island
Office_Desk
Office_Chair
Office_Computer
Office_Monitor
Office_Bookshelf
Office_FilingCabinet
Garage_PushPowerMower
Garage_ToolChest
Garage_AssortedLawnTools
Garage_Bicycle
Patio_Chair
Patio_SwingGlider
Patio_Table
Patio_GrillBarbeque
SpecialtyItems_ExerciseEquipment
SpecialtyItems_PoolTable
SpecialtyItems_LargeSafe
SpecialtyItems_KitchenAppliances
SpecialtyItems_LaundryAppliances
SpecialtyItems_Piano
SpecialtyItems_HotTub
Boxes
BusinessOffice_Desk
BusinessOffice_Chair
BusinessOffice_Credenza
BusinessOffice_FilingCabinet
BusinessOffice_Bookshelf
BusinessOffice_Dresser
BusinessFileRoom_FilingCabinet
BusinessFileRoom_Bookshelf
BusinessCopyRoom_SupplyCabinet
BusinessCopyRoom_ShelvingUnit
BusinessConferenceRoom_Table
BusinessConferenceRoom_Chair
BusinessConferenceRoom_Credenza
BusinessEquipment_Computer
BusinessEquipment_Monitor
BusinessEquipment_CopyMachine
BusinessEquipment_Printer
BusinessEquipment_SmallAppliances
BusinessReceptionArea_Desk
BusinessReceptionArea_Chair
BusinessReceptionArea_EndTable");
            var current = items.ReadLine();
            using(var sql = new SqlConnection("user id=dittmank;" +
                                       "password=rdelatable;server=mysql-user.cse.msu.edu;" +
                                       "Trusted_Connection=false;" +
                                       "database=dittmank; " +
                                       "connection timeout=15"))
            {
                try
                {
                    sql.Open();
                }
                catch (Exception e)
                {
                    var err = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                    err.ReasonPhrase = e.Message;
                    return err;
                }
                //while (current != null)
                //{
                //    current = items.ReadLine();
                //}
            }
            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}
