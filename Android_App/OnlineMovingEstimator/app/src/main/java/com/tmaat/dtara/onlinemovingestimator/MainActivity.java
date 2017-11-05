package com.tmaat.dtara.onlinemovingestimator;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.ViewParent;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    public static Estimate est;
    ActionBar actionbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Typeface face;
        face = Typeface.createFromAsset(getAssets(),"1.otf");
        TextView textView = (TextView)findViewById(R.id.enterCode);
        textView.setTypeface(face);
        textView.setTextColor(Color.WHITE);
        Button button1 = (Button)findViewById(R.id.finish);
        button1.setTypeface(face);
    }

    public void onCheckCode(final View view){

        EditText new_id = (EditText)findViewById(R.id.idText);
        final String newID =  new_id.getText().toString();
        est = new Estimate(newID.toString());
        updateUI(view);

        /*
         * Create a thread to verify estimate ID from cloud
         */
        //new Thread(new Runnable() {

          //  @Override
          //  public void run() {

          //      Cloud cloud = new Cloud();
          //      final boolean ok = cloud.checkEstimateID(newID);
          //      if(!ok) {
          //          /*
          //           * If we fail to save, display a toast
          //           */
          //          // Please fill this in...
          //          view.post(new Runnable() {

          //              @Override
          //              public void run() {
          //                  Toast.makeText(view.getContext(), "Not a Valid Estimate ID", Toast.LENGTH_SHORT).show();
          //              }
          //          });
          //      } else {
          //          est = new Estimate(newID.toString());
          //          updateUI(view);
          //      }
          //  }
        //}).start();
    }

    public void updateUI(View view) {
        Intent intent = new Intent(this, Intro.class);
        startActivity(intent);
    }
}
