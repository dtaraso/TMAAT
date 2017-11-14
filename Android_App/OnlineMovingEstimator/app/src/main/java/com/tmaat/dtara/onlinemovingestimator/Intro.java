package com.tmaat.dtara.onlinemovingestimator;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class Intro extends AppCompatActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_intro);

        final View view = findViewById(android.R.id.content);
        new Thread(new Runnable() {
            @Override
            public void run() {
                Cloud cloud = new Cloud();
                final boolean ok = cloud.getItems();
            }
        }).start();

        Typeface face;
        face = Typeface.createFromAsset(getAssets(),"1.otf");
        TextView textView = (TextView)findViewById(R.id.aboutTitle);
        textView.setTypeface(face);
        Typeface face2;
        face2 = Typeface.createFromAsset(getAssets(),"Calibri.ttf");
        TextView textView1 = (TextView)findViewById(R.id.textView2);
        textView1.setTypeface(face2);
        textView.setTextColor(Color.WHITE);
        textView1.setTextColor(Color.WHITE);
        Button button1 = (Button)findViewById(R.id.button);
        button1.setTypeface(face);
    }

    public void onContinue(View view) {
        Intent intent = new Intent(this, camera.class);
        startActivity(intent);
    }
}
