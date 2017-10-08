package com.tmaat.dtara.onlinemovingestimator;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void onCheckCode(final View view){

        EditText new_id = (EditText)findViewById(R.id.idText);
        final String newID =  new_id.getText().toString();

        /*
         * Create a thread to load the hatting from the cloud
         */
        new Thread(new Runnable() {

            @Override
            public void run() {

                Cloud cloud = new Cloud();
                final boolean ok = cloud.checkEstimateID(newID);
                if(!ok) {
                    /*
                     * If we fail to save, display a toast
                     */
                    // Please fill this in...
                    view.post(new Runnable() {

                        @Override
                        public void run() {
                            Toast.makeText(view.getContext(), "Not a Valid Estimate ID", Toast.LENGTH_SHORT).show();
                        }
                    });
                } else {
                    Estimate est = new Estimate(newID.toString());
                    updateUI(view);
                }
            }
        }).start();
    }

    public void updateUI(View view) {
        Intent intent = new Intent(this, Intro.class);
        startActivity(intent);
    }
}
