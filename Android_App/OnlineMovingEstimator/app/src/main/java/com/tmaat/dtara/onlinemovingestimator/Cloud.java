package com.tmaat.dtara.onlinemovingestimator;

import android.content.Context;
import android.content.Intent;
import android.util.Base64;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Map;
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
    // base url for Personal MSU Capstone Server
    private static final String WEB_BASE_URL = "http://35.9.22.105:8555/";
    // base url for TWO MEN AND A TRUCK's API
    private static final String TMAAT_BASE_URL = "https://mwc.test.twomen.com/";
    // Arraylist of furniture detected within image
    public static ArrayList<ImageResponse> imgResponse = new ArrayList<ImageResponse>();
    // Arraylist of all available furniture (getItems function)
    public static ArrayList<ImageResponse> furnResponse = new ArrayList<ImageResponse>();
    // Object as response from TMAAT API
    public static QuickEstimateResponse EstimateResponse = new QuickEstimateResponse();
    // Username and password for authorization of TMAAT API
    private String username = "twomen\\msucapstone";
    private String password = "Vf@tN7Ck";

    private ImageService initialize() {
        // Function to initialize the okHttpClient to use with MSU Capstone API
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
        return service;
    }

    private ImageService tmaat_initialize() {
        // Function similar to one above but initializes to TMAAT API
        OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .readTimeout(60, TimeUnit.SECONDS)
                .connectTimeout(60, TimeUnit.SECONDS)
                .build();

        Retrofit retrofit = new Retrofit.Builder()
                .addConverterFactory(GsonConverterFactory.create())
                .client(okHttpClient)
                .baseUrl(TMAAT_BASE_URL) //(API BASE URL)
                .build();

        ImageService service = retrofit.create(ImageService.class);
        return service;
    }

    public boolean getItems() {
        // Function calls a get request to obtain a list of all available furniture

        // initializes service to MSU Capstone API
        ImageService service = initialize();
        // Calls getItems function
        service.getItems();
        Call<ArrayList<ImageResponse>> call = service.getItems();

        call.enqueue(new Callback<ArrayList<ImageResponse>>() {
            @Override
            public void onResponse(Call<ArrayList<ImageResponse>> call, Response<ArrayList<ImageResponse>> response) {
                // If response is successful
                if (response.isSuccessful()) {
                    Log.e("476", "on response get items");
                    // place body of response within arraylist of furniture
                    furnResponse = response.body();
                } else {
                    Log.e("476", "GetItems response is not successful");
                }
            }

            @Override
            public void onFailure(Call<ArrayList<ImageResponse>> call, Throwable t) {
                Log.e("476","getItems FAILURE");
                Log.e("476",t.getMessage());
            }
        });
        return true;
    }

    public boolean ImageUpload(byte[] data) {
        // Function uploads image to MSU API and saves response to the imgResponse array

        String room = MainActivity.est.room;
        int imgNum = MainActivity.est.nextAvailableImageNumber();
        // create new image object if camera was used to take image
        final Image img = new Image(imgNum, MainActivity.est.room);
        MainActivity.est.addToImageList(img);

        // Initialize service
        ImageService service = initialize();

        // Create a jpeg file to save the image data to
        RequestBody requestFile =
                RequestBody.create(MediaType.parse("image/jpeg"), data);
        // Place the jpeg into a multipart file
        MultipartBody.Part body =
                MultipartBody.Part.createFormData("image", "image.jpeg", requestFile);

        // Initialize the postImage function
        service.postImage(room,body);
        Call<ArrayList<ImageResponse>> call = service.postImage(room,body);
        call.enqueue(new Callback<ArrayList<ImageResponse>>() {
            @Override
            public void onResponse(Call<ArrayList<ImageResponse>> call, Response<ArrayList<ImageResponse>> response) {
                if (response.isSuccessful()) {
                    Log.e("476","image upload Response");
                    // Place contents of response into the imgResponse array
                    imgResponse = response.body();
                    // This image is done loading
                    img.setLoading(false);
                    // For this image, set the response as its imageResponse array
                    img.setImageArray(imgResponse);
                } else {
                    Log.e("476", "Got response but not a good one");
                }
            }

            @Override
            public void onFailure(Call<ArrayList<ImageResponse>> call, Throwable t) {
                Log.e("476","image upload FAILURE");
                Log.e("476",t.getMessage());
            }
        });
        return true;
    }

    public boolean FurnitureUpload(final Context context) {
        // Function creates JSON array and sends it to TMAAT Quick Estimate API

        // Call function to update number of furniture in each room
        MainActivity.est.updateRoomList();
        // Call the create JSON function
        JSONObject finalJSON = createJSON();
        Log.e("476",finalJSON.toString());
        // Initialize service according to TMAAT
        ImageService service = tmaat_initialize();
        // Create authorization string
        String basicAuth = "Basic " + Base64.encodeToString((username+":"+password).getBytes(), Base64.NO_WRAP);

        // Call the API function
        service.postJSON(basicAuth, finalJSON);
        Call<QuickEstimateResponse> call = service.postJSON(basicAuth, finalJSON);
        call.enqueue(new Callback<QuickEstimateResponse>() {
            @Override
            public void onResponse(Call<QuickEstimateResponse> call, Response<QuickEstimateResponse> response) {
                if (response.isSuccessful()) {
                    // Save the response contents to EstimateResponse
                    EstimateResponse = response.body();
                    // Start an intent to go to the quick estimate page
                    Intent intent = new Intent(context, QuickEstimate.class);
                    context.startActivity(intent);
                } else {
                    Log.e("476", "Unsuccessful response from furniture upload function");
                }
            }

            @Override
            public void onFailure(Call<QuickEstimateResponse> call, Throwable t) {
                Log.e("476","TMAAT upload FAILURE");
                Log.e("476",t.getMessage());
            }
        });
        return true;
    }

    public JSONObject createJSON() {
        // Function to create json array to use in TMAAT post request

        // get estimate id
        String estimateID = MainActivity.est.getId();

        try {
            // Create the main array where the subarrays will be kept
            JSONObject jsonBody = new JSONObject()
                    .put("estimateid", estimateID);
            // Create the room array where all of the room objects will be kept
            JSONArray roomArray = new JSONArray();
            // Loop through the room - list of furniture map to create proper nesting of json arrays
            for (Map.Entry<String,ArrayList<Furniture>> pair : MainActivity.est.roomFurnList.entrySet()){
                //iterate over the pairs
                JSONObject roomBody = new JSONObject();
                JSONArray furnBody = new JSONArray();
                // For each piece of furniture, place its information within the json object
                for (Furniture f: pair.getValue()) {
                    JSONObject furnArray = new JSONObject()
                            .put("id", f.getID())
                            .put("name", f.getName())
                            .put("quantity", f.getNumOfFurn());
                    furnBody.put(furnArray);
                }
                // place the room information within the json object
                roomBody.put("id",MainActivity.est.roomID.get(pair.getKey()));
                roomBody.put("name",pair.getKey());
                roomBody.put("items", furnBody);
                // place the json object within the room array
                roomArray.put(roomBody);
            }
            // Place the room array within the main json after done iterating through the rooms
            jsonBody.put("rooms",roomArray);
            return jsonBody;
        } catch (JSONException e) {
            // Catch JSON exceptions and print failure message
            Log.e("476", e.getMessage());
            return new JSONObject();
        }
    }
}
