package com.tmaat.dtara.onlinemovingestimator;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class Intro extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_intro);
    }

    public void onContinue(View view) {
        Intent intent = new Intent(this, camera.class);
        startActivity(intent);
    }


}
