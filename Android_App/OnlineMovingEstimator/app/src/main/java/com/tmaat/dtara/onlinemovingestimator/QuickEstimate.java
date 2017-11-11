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

        if (Cloud.EstimateResponse.success) {
            est.setText("$ "+Cloud.EstimateResponse.totalCost);
        } else {
            est.setText("There was an error on our part.");
        }
    }
}
