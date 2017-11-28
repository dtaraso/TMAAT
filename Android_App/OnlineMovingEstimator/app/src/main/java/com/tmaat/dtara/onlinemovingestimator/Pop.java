package com.tmaat.dtara.onlinemovingestimator;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

public class Pop extends AppCompatActivity {

    private RadioGroup roomGroup;
    private RadioButton radioButton;
    private Button btnDisplay;

    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pop);
/*
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.x = -20;
        params.height = 1300;
        params.width = 900;
        params.y = -10;

        this.getWindow().setAttributes(params);

        Typeface face;
        face = Typeface.createFromAsset(getAssets(),"1.otf");
        TextView textView = (TextView)findViewById(R.id.roomTitle);
        textView.setTypeface(face);
        textView.setTextColor(Color.WHITE);
        Typeface face2;
        face2 = Typeface.createFromAsset(getAssets(),"Calibri.ttf");
        RadioButton button1 = (RadioButton) findViewById(R.id.bedroom);
        button1.setTextColor(getColor(R.color.color3));
        button1.setTypeface(face2);
        RadioButton button2 = (RadioButton) findViewById(R.id.livingRoom);
        button2.setTextColor(getColor(R.color.color3));
        button2.setTypeface(face2);
        RadioButton button3 = (RadioButton) findViewById(R.id.diningRoom);
        button3.setTextColor(getColor(R.color.color3));
        button3.setTypeface(face2);
        RadioButton button4 = (RadioButton) findViewById(R.id.kitchen);
        button4.setTextColor(getColor(R.color.color3));
        button4.setTypeface(face2);
        RadioButton button5 = (RadioButton) findViewById(R.id.office);
        button5.setTextColor(getColor(R.color.color3));
        button5.setTypeface(face2);
        RadioButton button6 = (RadioButton) findViewById(R.id.garage);
        button6.setTextColor(getColor(R.color.color3));
        button6.setTypeface(face2);
        RadioButton button7 = (RadioButton) findViewById(R.id.patio);
        button7.setTextColor(getColor(R.color.color3));
        button7.setTypeface(face2);
        RadioButton button8 = (RadioButton) findViewById(R.id.businessOffice);
        button8.setTextColor(getColor(R.color.color3));
        button8.setTypeface(face2);
        RadioButton button9 = (RadioButton) findViewById(R.id.businessFileRoom);
        button9.setTextColor(getColor(R.color.color3));
        button9.setTypeface(face2);
        RadioButton button10 = (RadioButton) findViewById(R.id.businessCopyRoom);
        button10.setTextColor(getColor(R.color.color3));
        button10.setTypeface(face2);
        RadioButton button11 = (RadioButton) findViewById(R.id.businessReceptionArea);
        button11.setTextColor(getColor(R.color.color3));
        button11.setTypeface(face2);

        Button button = (Button)findViewById(R.id.DoneButton);
        button.setTypeface(face);
        */
        addListenerOnButton();
    }

    public void addListenerOnButton() {

        // Creates variables for the radio group and done button
        roomGroup = (RadioGroup) findViewById(R.id.roomRadioGroup);
        btnDisplay = (Button) findViewById(R.id.DoneButton);

        // Create a listener for the done button
        btnDisplay.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                // Get selected radio button from radioGroup
                int selectedId = roomGroup.getCheckedRadioButtonId();

                // If a radio button was not selected, display a warning toast
                if (selectedId == -1) {
                    View view = findViewById(android.R.id.content);
                    Toast.makeText(view.getContext(),"Select a room before continuing",Toast.LENGTH_LONG).show();
                } else {
                    // Find the radiobutton by returned id
                    radioButton = (RadioButton) findViewById(selectedId);
                    // Set the current room in the predefined estimate object
                    MainActivity.est.addCurrentRoom((String) radioButton.getText());
                    finish();
                }
            }

        });
    }
}
