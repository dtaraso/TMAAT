package com.tmaat.dtara.onlinemovingestimator;

import android.util.Base64;
import android.util.Log;
import android.util.Xml;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by dtara on 9/25/2017.
 */

public class Cloud {
    private static final String MAGIC = "NechAtHa6RuzeR8x";
    private static final String USER = "dittmank";
    private static final String PASSWORD = " rdelatable";
    private static final String LOGIN_URL = "http://webdev.cse.msu.edu/~tarasov1/cse476/tmaat/get_estimateid.php";
    private static final String WEB_API_URL = "http://35.9.22.105:8555/api/uploadImage";
    private static final String UTF8 = "UTF-8";
    private String base64;
    InputStream stream = null;


    public boolean checkEstimateID(final String estimateID) {
        // Create a get query
        String query = LOGIN_URL + "?user=" + USER + "&magic=" + MAGIC + "&pw=" + PASSWORD + "&estimateid=" + estimateID;

        try {
            URL url = new URL(query);

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            int responseCode = conn.getResponseCode();
            if(responseCode != HttpURLConnection.HTTP_OK) {
                return false;
            }

            InputStream stream = conn.getInputStream();http://35.9.22.105:8555/api/uploadImage

            try {
                XmlPullParser xmlR = Xml.newPullParser();
                xmlR.setInput(stream, UTF8);

                xmlR.nextTag();      // Advance to first tag
                xmlR.require(XmlPullParser.START_TAG, null, "project");

                String status = xmlR.getAttributeValue(null, "status");
                if(status.equals("no")) {
                    return false;
                }

                // We are done
            } catch(XmlPullParserException ex) {
                return false;
            } catch(IOException ex) {
                return false;
            }

            return true;

        } catch (MalformedURLException e) {
            // Should never happen
            return false;
        } catch (IOException ex) {
            return false;
        }
    }

    public boolean ImageUpload(byte[] data) {
        String boundary = "*****" + Long.toString(System.currentTimeMillis()) + "*****";
        base64 = Base64.encodeToString(data, Base64.DEFAULT);


        try{

            URL url = new URL(WEB_API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            //conn.setRequestProperty("Content-Length", Integer.toString(data.length));
            conn.setRequestProperty("Connection", "Keep-Alive");
            conn.setRequestProperty("User-Agent", "Android Multipart HTTP Client 1.0");
            conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
            conn.setUseCaches(false);

            OutputStream out = conn.getOutputStream();
            //out.write(base64);
            out.write(data);
            out.close();

            int responseCode = conn.getResponseCode();
            if(responseCode != HttpURLConnection.HTTP_OK) {
                Log.e("476","RESPONSE CODE != HTTP OK");
                //Log.e("476",conn.getInputStream().toString());
                return false;
            }

            stream = conn.getInputStream();
            //logStream(stream);

        } catch (MalformedURLException e) {
            Log.e("476","MALFORMED URL");
            return false;
        } catch (IOException ex) {
            Log.e("476","IO Exception 1");
            Log.e("476",ex.getMessage());
            return false;
        } finally {
            if(stream != null) {
                try {
                    Log.e("476","SUCCESS SUCCESS SUCCESS");
                    stream.close();
                } catch(IOException ex) {
                    Log.e("476","IO Exception 2");
                    // Fail silently
                }
            }
        }
        Log.e("476","TRUE TRUE TRUE");
        return true;
    }
}
