using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Web;

namespace TMAAT_WebAPI.Resources
{
    public class PasswordService
    {
        public string[] hashPassword(string password) {
            byte[] salt;
            new RNGCryptoServiceProvider().GetBytes(salt = new byte[16]);
            var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000);
            byte[] hash = pbkdf2.GetBytes(20);

            string[] result = { Convert.ToBase64String(hash), Convert.ToBase64String(salt) };
            return result;
        }

        public bool verifyPassword(string password, string saltDB, string hashDB) {
            var salt = Convert.FromBase64String(saltDB);
            var hashBytes = Convert.FromBase64String(hashDB);

            var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000);
            byte[] hash = pbkdf2.GetBytes(20);
            /* Compare the results */
            for (int i = 0; i < 20; i++) {
                if (hashBytes[i] != hash[i]) {
                    return false;
                }
            }
            return true;
        }

        public string generateToken()
        {
            byte[] token;
            new RNGCryptoServiceProvider().GetBytes(token = new byte[16]);
            
            return Convert.ToBase64String(token);
        }
    }
}