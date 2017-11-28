package com.tmaat.dtara.onlinemovingestimator;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
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
import java.util.List;

import static com.tmaat.dtara.onlinemovingestimator.Cloud.furnResponse;
import static com.tmaat.dtara.onlinemovingestimator.Cloud.imgResponse;

public class FurnConfirm extends AppCompatActivity {
    // Save the image number
    private int imageNum;
    // Save the image object
    private Image img;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        Bundle extras = getIntent().getExtras();
        if(extras == null) {
            imageNum= -1;
        } else {
            // Get the image number passed over
            imageNum= extras.getInt("ImageNum");
        }
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_furn_confirm);
        displayListView();
    }

    FurnConfirm.MyCustomAdapter dataAdapter = null;

    private void displayListView() {

        //Array list of furniture
        img = MainActivity.est.getImage(imageNum);
        ArrayList<Furniture> furnList = img.getFurnList();
        ListView listView = (ListView) findViewById(R.id.listFurn);

        // If furniture was detected within the image
        if (furnList.size() != 0) {
            //create an ArrayAdaptar from the String Array
            dataAdapter = new FurnConfirm.MyCustomAdapter(this,
                    R.layout.activity_furn_catalog, furnList);
            // Assign adapter to ListView
            listView.setAdapter(dataAdapter);
        } else {
            // Hide the list view
            listView.setVisibility(View.GONE);
            RelativeLayout rl = (RelativeLayout) findViewById(R.id.furnConfirm);
            TextView txt = new TextView(this);
            // Set text to display that the image found no furniture
            txt.setText("No Furniture Found");
            rl.addView(txt);
        }

    }

    private class MyCustomAdapter extends ArrayAdapter<Furniture> {
    // Define the adapter

        private ArrayList<Furniture> furnList;

        public MyCustomAdapter(Context context, int textViewResourceId,
                               ArrayList<Furniture> furnList) {
            super(context, textViewResourceId, furnList);
            this.furnList = new ArrayList<Furniture>();
            this.furnList.addAll(furnList);
        }

        // Define the components of the furniture row
        private class ViewHolder {
            CheckBox name;
            Button classify;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {

            FurnConfirm.MyCustomAdapter.ViewHolder holder = null;

            if (convertView == null) {
                LayoutInflater vi = (LayoutInflater)getSystemService(
                        Context.LAYOUT_INFLATER_SERVICE);
                convertView = vi.inflate(R.layout.activity_furn_catalog, null);

                holder = new FurnConfirm.MyCustomAdapter.ViewHolder();
                holder.name = (CheckBox) convertView.findViewById(R.id.checkBox1);
                holder.classify = (Button) convertView.findViewById(R.id.classify_furn);
                convertView.setTag(holder);

                // If the checkbox was clicked
                holder.name.setOnClickListener( new View.OnClickListener() {
                    public void onClick(View v) {
                        CheckBox cb = (CheckBox) v ;
                        Furniture furn = (Furniture) cb.getTag();
                        furn.setSelected(cb.isChecked());
                    }
                });

                final FurnConfirm.MyCustomAdapter.ViewHolder holder1 = holder;
                // If the user clicked on the classify button
                holder.classify.setOnClickListener( new View.OnClickListener() {
                    public void onClick(View v) {
                        Button cb = (Button) v ;
                        
                        final Furniture furn = (Furniture) cb.getTag();
                        List<String> furnItems = getItems(furn);
                        List<String> furnIDs = getIDs(furn);
                        final CharSequence[] items_final = furnItems.toArray(new CharSequence[furnItems.size()]);
                        final CharSequence[] IDs_final = furnIDs.toArray(new CharSequence[furnIDs.size()]);
                        Context context = v.getContext();
                        AlertDialog.Builder builder = new AlertDialog.Builder(context);
                        builder.setTitle("Select Furniture Type");
                        builder.setItems(items_final, new DialogInterface.OnClickListener() {

                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                String furn_name = (String) items_final[which];
                                String furn_id = (String) IDs_final[which];
                                holder1.name.setText(furn_name);
                                furn.setName(furn_name);
                                furn.setID(furn_id);
                                dialog.cancel();
                            }
                        });
                        AlertDialog alert = builder.create();
                        alert.show();
                    }
                });
            }
            else {
                holder = (FurnConfirm.MyCustomAdapter.ViewHolder) convertView.getTag();
            }

            //Log.e("POS",String.valueOf(position));
            //Log.e("SIZE",String.valueOf(furnList.size()));
            Furniture furn = furnList.get(position);
            holder.name.setText(furn.getName());
            holder.name.setChecked(furn.isSelected());
            holder.name.setTag(furn);
            holder.classify.setTag(furn);

            if (furn.quantity.size() <= 1) {
                holder.classify.setVisibility(View.GONE);
            }
            return convertView;
        }
    }

    public void onSave(View view) {
        Intent intent = new Intent(this, ImageConfirm.class);
        startActivity(intent);
    }

    public void onDeleteImg(View view){
        img = null;
        MainActivity.est.removeImage(imageNum);
        Intent intent = new Intent(this, ImageConfirm.class);
        startActivity(intent);
    }

    public void onAddItem(View view) {
        List<String> furnItems = getAllItems();
        List<String> furnIDs = getAllIds();
        final CharSequence[] items_final = furnItems.toArray(new CharSequence[furnItems.size()]);
        final CharSequence[] IDs_final = furnIDs.toArray(new CharSequence[furnIDs.size()]);
        Context context = view.getContext();
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle("Select Furniture Type");
        builder.setItems(items_final, new DialogInterface.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {
                String furn_name = (String) items_final[which];
                String furn_id = (String) IDs_final[which];
                Furniture newFurn = new Furniture(furn_name, furn_id);
                dataAdapter.furnList.add(newFurn);
                img.AddToFurnList(newFurn);
                dialog.cancel();
                dataAdapter.notifyDataSetChanged();
            }
        });
        AlertDialog alert = builder.create();
        alert.show();
    }


    private List<String> getAllItems() {
        List<String> items = new ArrayList<String>();
        for (ImageResponse i: furnResponse) {
            items.add(i.name);
        }
        return items;
    }

    private List<String> getAllIds() {
        List<String> items = new ArrayList<String>();
        for (ImageResponse i: furnResponse) {
            items.add(i.id);
        }
        return items;
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

    private List<String> getIDs(Furniture furn) {
        List<String> items = new ArrayList<String>();
        for (ImageResponse i: furnResponse) {
            if (furn.quantity.contains(i.id)){
                items.add(i.id);
            }
        }
        return items;
    }
}
