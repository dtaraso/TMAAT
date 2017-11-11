package com.tmaat.dtara.onlinemovingestimator;

import android.util.Base64;

import org.json.JSONObject;

import java.util.ArrayList;

import okhttp3.Credentials;
import okhttp3.MultipartBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.Part;
import retrofit2.http.Query;

/**
 * Created by dtara on 10/11/2017.
 */

public interface ImageService {

    @Multipart
    @POST("api/uploadImage")
    Call<ArrayList<ImageResponse>> postImage(@Query("room") String room, @Part MultipartBody.Part data);


    @GET("api/getItems")
    Call<ArrayList<ImageResponse>> getItems();

    @Headers({"Content-Type: application/json"})
    @POST("mwcwebapi/estimate/addInventoryToEstimate")
    Call<QuickEstimateResponse> postJSON(@Header("Authorization") String basicAuth, @Body JSONObject jsonBody);
}
