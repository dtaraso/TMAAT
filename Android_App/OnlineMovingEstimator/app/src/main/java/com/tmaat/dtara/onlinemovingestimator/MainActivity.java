package com.tmaat.dtara.onlinemovingestimator;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    public static Estimate est;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Design Portion
        Typeface face;
        face = Typeface.createFromAsset(getAssets(),"1.otf");
        TextView textView = (TextView)findViewById(R.id.enterCode);
        textView.setTypeface(face);
        textView.setTextColor(Color.WHITE);
        Button button1 = (Button)findViewById(R.id.save);
        button1.setTypeface(face);
    }

    public void onCheckCode(final View view){

        // Creates new estimate object based on user input
        EditText new_id = (EditText)findViewById(R.id.idText);
        final String newID =  new_id.getText().toString();
        est = new Estimate(newID.toString());
        updateUI(view);

    }

    public void updateUI(View view) {

        // Function starts new intent to go to intro page
        Intent intent = new Intent(this, Intro.class);
        startActivity(intent);
    }
}
