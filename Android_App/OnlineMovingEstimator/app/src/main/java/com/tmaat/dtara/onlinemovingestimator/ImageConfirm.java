package com.tmaat.dtara.onlinemovingestimator;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;

public class ImageConfirm extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_image_confirm);

        displayListView();
        checkButtonClick();
    }

    ImageConfirm.MyCustomAdapter dataAdapter = null;

    private void displayListView() {

        //Array list of countries
        ArrayList<Furniture> furnList = new ArrayList<Furniture>();
        Furniture furn = new Furniture("Table",false);
        furnList.add(furn);
        Furniture furn1 = new Furniture("Chair",false);
        furnList.add(furn1);
        Furniture furn2 = new Furniture("Bed",false);
        furnList.add(furn2);

        //create an ArrayAdaptar from the String Array
        dataAdapter = new ImageConfirm.MyCustomAdapter(this,
                R.layout.activity_furn_catalog, furnList);
        ListView listView = (ListView) findViewById(R.id.listFurn);
        // Assign adapter to ListView
        listView.setAdapter(dataAdapter);


        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {
                // When clicked, show a toast with the TextView text
                Furniture furn = (Furniture) parent.getItemAtPosition(position);
                Toast.makeText(getApplicationContext(),
                        "Clicked on Row: " + furn.getName(),
                        Toast.LENGTH_LONG).show();
            }
        });

    }

    private class MyCustomAdapter extends ArrayAdapter<Furniture> {

        private ArrayList<Furniture> furnList;

        public MyCustomAdapter(Context context, int textViewResourceId,
                               ArrayList<Furniture> furnList) {
            super(context, textViewResourceId, furnList);
            this.furnList = new ArrayList<Furniture>();
            this.furnList.addAll(furnList);
        }

        private class ViewHolder {
            TextView code;
            CheckBox name;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {

            ImageConfirm.MyCustomAdapter.ViewHolder holder = null;
            Log.v("ConvertView", String.valueOf(position));

            if (convertView == null) {
                LayoutInflater vi = (LayoutInflater)getSystemService(
                        Context.LAYOUT_INFLATER_SERVICE);
                convertView = vi.inflate(R.layout.activity_furn_catalog, null);

                holder = new ImageConfirm.MyCustomAdapter.ViewHolder();
                holder.code = (TextView) convertView.findViewById(R.id.code);
                holder.name = (CheckBox) convertView.findViewById(R.id.checkBox1);
                convertView.setTag(holder);

                holder.name.setOnClickListener( new View.OnClickListener() {
                    public void onClick(View v) {
                        CheckBox cb = (CheckBox) v ;
                        Furniture furn = (Furniture) cb.getTag();
                        Toast.makeText(getApplicationContext(),
                                "Clicked on Checkbox: " + cb.getText() +
                                        " is " + cb.isChecked(),
                                Toast.LENGTH_LONG).show();
                        furn.setSelected(cb.isChecked());
                    }
                });
            }
            else {
                holder = (ImageConfirm.MyCustomAdapter.ViewHolder) convertView.getTag();
            }

            Furniture furn = furnList.get(position);
            holder.name.setText(furn.getName());
            holder.name.setChecked(furn.isSelected());
            holder.name.setTag(furn);

            return convertView;

        }
    }

    public void onRetake(View view) {
        Intent intent = new Intent(this, camera.class);
        startActivity(intent);
    }

    public void onTakeAnother(View view) {
        // TODO: Add furniture to estimate class
        Intent intent = new Intent(this, camera.class);
        startActivity(intent);
    }

    private void checkButtonClick() {
        Button myButton = (Button) findViewById(R.id.finish);
        myButton.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                StringBuffer responseText = new StringBuffer();
                responseText.append("The following were selected...\n");

                ArrayList<Furniture> furnList = dataAdapter.furnList;
                for(int i=0;i<furnList.size();i++){
                    Furniture furn = furnList.get(i);
                    if(furn.isSelected()){
                        responseText.append("\n" + furn.getName());
                    }
                }
                Toast.makeText(getApplicationContext(),
                        responseText, Toast.LENGTH_LONG).show();
            }
        });
    }

}
