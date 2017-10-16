package com.tmaat.dtara.onlinemovingestimator;

import android.app.Activity;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Toast;

public class Pop extends AppCompatActivity {

    private RadioGroup roomGroup;
    private RadioButton radioButton;
    private Button btnDisplay;

    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pop);

        addListenerOnButton();
    }

    public void addListenerOnButton() {

        roomGroup = (RadioGroup) findViewById(R.id.roomRadioGroup);
        btnDisplay = (Button) findViewById(R.id.DoneButton);

        btnDisplay.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                // get selected radio button from radioGroup
                int selectedId = roomGroup.getCheckedRadioButtonId();

                if (selectedId == -1) {
                    View view = findViewById(android.R.id.content);
                    Toast.makeText(view.getContext(),"Select a room before continuing",Toast.LENGTH_LONG).show();
                } else {
                    // find the radiobutton by returned id
                    radioButton = (RadioButton) findViewById(selectedId);
                    MainActivity.est.addCurrentRoom((String) radioButton.getText());
                    finish();
                }
            }

        });
    }
}
