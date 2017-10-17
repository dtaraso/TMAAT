package com.tmaat.dtara.onlinemovingestimator;

import android.util.Log;
import android.util.Xml;
import android.view.View;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.concurrent.TimeUnit;

import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by dtara on 9/25/2017.
 */

public class Cloud {
    private static final String MAGIC = "NechAtHa6RuzeR8x";
    private static final String USER = "dittmank";
    private static final String PASSWORD = " rdelatable";
    private static final String LOGIN_URL = "http://webdev.cse.msu.edu/~tarasov1/cse476/tmaat/get_estimateid.php";
    private static final String WEB_BASE_URL = "http://35.9.22.105:8555/";
    private static final String UTF8 = "UTF-8";
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

            InputStream stream = conn.getInputStream();

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
        Log.e("476", "In ImageUpload Function");
        String room = MainActivity.est.room;

        OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .readTimeout(60, TimeUnit.SECONDS)
                .connectTimeout(60, TimeUnit.SECONDS)
                .build();

        Retrofit retrofit = new Retrofit.Builder()
                .addConverterFactory(GsonConverterFactory.create())
                .client(okHttpClient)
                .baseUrl(WEB_BASE_URL) //(API BASE URL)
                .build();


        ImageService service = retrofit.create(ImageService.class);

        RequestBody requestFile =
                RequestBody.create(MediaType.parse("image/jpeg"), data);
        MultipartBody.Part body =
                MultipartBody.Part.createFormData("image", "image.jpeg", requestFile);

        service.postImage(room,body);
        Call<ArrayList<ImageResponse>> call = service.postImage(room,body);
        call.enqueue(new Callback<ArrayList<ImageResponse>>() {
            @Override
            public void onResponse(Call<ArrayList<ImageResponse>> call, Response<ArrayList<ImageResponse>> response) {
                Log.e("476","onResponse");
                Log.e("476",response.toString());
                ArrayList<ImageResponse> imgResponse = response.body();
            }

            @Override
            public void onFailure(Call<ArrayList<ImageResponse>> call, Throwable t) {
                Log.e("476","FAILURE");
                Log.e("476",t.getMessage());
            }
        });
        return true;
    }
}
