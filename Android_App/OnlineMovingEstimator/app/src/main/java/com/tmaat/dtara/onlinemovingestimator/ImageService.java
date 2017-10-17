package com.tmaat.dtara.onlinemovingestimator;

import java.util.ArrayList;

import okhttp3.MultipartBody;
import retrofit2.Call;
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
}
