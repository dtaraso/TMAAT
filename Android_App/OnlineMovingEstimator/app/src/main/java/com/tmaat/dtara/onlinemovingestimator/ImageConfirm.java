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
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;

import static com.tmaat.dtara.onlinemovingestimator.Cloud.imgResponse;

public class ImageConfirm extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_image_confirm);

        setUpFurnitureList();
        displayListView();
        checkButtonClick();
    }

    ImageConfirm.MyCustomAdapter dataAdapter = null;

    private void displayListView() {

        //Array list of furniture
        ArrayList<Furniture> furnList = MainActivity.est.getTempList();
        ListView listView = (ListView) findViewById(R.id.listFurn);

        if (furnList.size() != 0) {
            //create an ArrayAdaptar from the String Array
            dataAdapter = new ImageConfirm.MyCustomAdapter(this,
                    R.layout.activity_furn_catalog, furnList);
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
        } else {
            listView.setVisibility(View.GONE);
            RelativeLayout rl = (RelativeLayout) findViewById(R.id.imgConfirm);
            TextView txt = new TextView(this);
            txt.setText("No Furniture Collected");
            rl.addView(txt);
        }

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
            CheckBox name;
            Button classify;
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
                holder.name = (CheckBox) convertView.findViewById(R.id.checkBox1);
                holder.classify = (Button) convertView.findViewById(R.id.classify_furn);
                convertView.setTag(holder);

                holder.classify.setVisibility(View.GONE);

                holder.name.setOnClickListener( new View.OnClickListener() {
                    public void onClick(View v) {
                        CheckBox cb = (CheckBox) v ;
                        View parentRow = (View) v.getParent();
                        ListView listView = (ListView) parentRow.getParent();
                        int position = listView.getPositionForView(parentRow);
                        Furniture furn = (Furniture) cb.getTag();
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
        MainActivity.est.resetTempList();
        imgResponse.clear();
        Intent intent = new Intent(this, camera.class);
        startActivity(intent);
    }

    public void onTakeAnother(View view) {
        MainActivity.est.addToTotalList();
        imgResponse.clear();
        Intent intent = new Intent(this, camera.class);
        startActivity(intent);
    }

    private void checkButtonClick() {
        Button myButton = (Button) findViewById(R.id.finish);
        myButton.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                MainActivity.est.addToTotalList();
                Intent intent = new Intent(v.getContext(), FinalizeList.class);
                v.getContext().startActivity(intent);
            }
        });
    }

    public void setUpFurnitureList() {
        if (imgResponse.size() != 0) {
            for (ImageResponse i: imgResponse) {
                String str = i.generic;
                String cap = str.substring(0, 1).toUpperCase() + str.substring(1);
                Furniture furn = new Furniture(cap, true, MainActivity.est.room, i.relatedInCategory);
                MainActivity.est.addToTempList(furn);
            }
        }
    }
}
