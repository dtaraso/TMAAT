package com.tmaat.dtara.onlinemovingestimator;

import android.app.Activity;
import android.os.Bundle;
import android.os.SystemClock;
import android.util.DisplayMetrics;
import android.view.View;
import android.widget.Button;

/**
 * Created by yeliy on 2017/10/4.
 */
public class Pop extends Activity{
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.room_choice);

        DisplayMetrics dm = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(dm);
        int width = dm.widthPixels;
        int height = dm.heightPixels;

        getWindow().setLayout((int) (width* .8),(int) (height* .6));

        Button button1 = (Button) findViewById(R.id.Bedroom);
        button1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //bedroom
                SystemClock.sleep(1000);
                finish();
            }
        });
        Button button2 = (Button) findViewById(R.id.Kitchen);
        button2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //kitchen
                SystemClock.sleep(1000);
                finish();
            }
        });
        Button button3 = (Button) findViewById(R.id.Livingroom);
        button3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //livingroom
                SystemClock.sleep(1000);
                finish();
            }
        });
        Button button4 = (Button) findViewById(R.id.Bathroom);
        button4.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Bathroom
                SystemClock.sleep(1000);
                finish();
            }
        });
    }
}
