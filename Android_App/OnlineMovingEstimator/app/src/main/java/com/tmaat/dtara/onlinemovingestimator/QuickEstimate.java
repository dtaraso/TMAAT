package com.tmaat.dtara.onlinemovingestimator;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.TextView;

public class QuickEstimate extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_quick_estimate);
        TextView est = (TextView) findViewById(R.id.estimate);

        // If there was a response from the TMAAT Quick Estimate API
        if (Cloud.EstimateResponse.success) {
            // Display the estimated cost returned
            est.setText("$ "+Cloud.EstimateResponse.totalCost);
        } else {
            // Display a warning message
            est.setText("There was an error on our part.");
        }
    }
}
