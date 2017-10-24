package com.tmaat.dtara.onlinemovingestimator;

import android.content.Context;
import android.content.DialogInterface;
import android.support.v4.content.res.TypedArrayUtils;
import android.support.v7.app.AlertDialog;
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
import java.util.Arrays;
import java.util.List;

import static com.tmaat.dtara.onlinemovingestimator.Cloud.furnResponse;

public class FinalizeList extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_finalize_list);

        displayListView();
        checkButtonClick();
    }

    FinalizeList.MyCustomAdapter dataAdapter = null;

    private void displayListView() {

        ArrayList<Furniture> furnList = MainActivity.est.getTotalList();
        ListView listView = (ListView) findViewById(R.id.listFurn);

        if (furnList.size() != 0) {
            //create an ArrayAdaptar from the String Array
            dataAdapter = new FinalizeList.MyCustomAdapter(this,
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
            txt.setText("No Furniture Was Detected");
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
            TextView code;
            CheckBox name;
            Button classify;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {

            FinalizeList.MyCustomAdapter.ViewHolder holder = null;
            Log.v("ConvertView", String.valueOf(position));

            if (convertView == null) {
                LayoutInflater vi = (LayoutInflater)getSystemService(
                        Context.LAYOUT_INFLATER_SERVICE);
                convertView = vi.inflate(R.layout.activity_furn_catalog, null);

                holder = new FinalizeList.MyCustomAdapter.ViewHolder();
                holder.code = (TextView) convertView.findViewById(R.id.code);
                holder.name = (CheckBox) convertView.findViewById(R.id.checkBox1);
                holder.classify = (Button) convertView.findViewById(R.id.classify_furn);
                holder.classify.setTag(holder);
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

                holder.classify.setOnClickListener( new View.OnClickListener() {
                        public void onClick(View v) {
                            // CharSequence[] items = { "Mango", "Banana", "Apple" };
                            Button cb = (Button) v ;

                            final ViewHolder parentRow = (ViewHolder) v.getParent();
                            Furniture furn = (Furniture) cb.getTag();
                        List<String> furnItems = getItems(furn);
                        CharSequence[] items = furnItems.toArray(new CharSequence[furnItems.size()]);
                            final CharSequence[] items_final = items;
                        Context context = v.getContext();
                        AlertDialog.Builder builder = new AlertDialog.Builder(context);
                        builder.setTitle("Select Furniture Type");
                        builder.setItems(items, new DialogInterface.OnClickListener() {

                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                String furn_name = (String) items_final[which];
                                parentRow.code.setText(furn_name);
                                dialog.cancel();
                            }
                        });
                        AlertDialog alert = builder.create();
                        alert.show();
                    }
                });
            }
            else {
                holder = (FinalizeList.MyCustomAdapter.ViewHolder) convertView.getTag();
            }

            Furniture furn = furnList.get(position);
            holder.name.setText(furn.getName());
            holder.name.setChecked(furn.isSelected());
            holder.name.setTag(furn);
            holder.classify.setTag(furn);

            if (furn.quantity.size() == 0) {
                holder.classify.setVisibility(View.GONE);
            }

            return convertView;

        }
    }

    private void checkButtonClick() {
        Button myButton = (Button) findViewById(R.id.done);
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

    private List<String> getItems(Furniture furn) {
        List<String> items = new ArrayList<String>();
        for (ImageResponse i: furnResponse) {
            if (furn.quantity.contains(i.id)){
                items.add(i.name);
            }
        }
        return items;
    }
}
