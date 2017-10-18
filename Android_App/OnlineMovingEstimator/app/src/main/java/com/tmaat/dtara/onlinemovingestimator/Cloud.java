package com.tmaat.dtara.onlinemovingestimator;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.View;

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
    private static final String WEB_BASE_URL = "http://35.9.22.105:8555/";
    public static ArrayList<ImageResponse> imgResponse;


    public boolean checkEstimateID(final String estimateID) {
        // TODO: get from TMAAT API to verify estimate id
        return true;
    }

    public boolean ImageUpload(byte[] data, View view, final Context context) {
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
                imgResponse = response.body();
                Intent intent = new Intent(context, ImageConfirm.class);
                context.startActivity(intent);
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
