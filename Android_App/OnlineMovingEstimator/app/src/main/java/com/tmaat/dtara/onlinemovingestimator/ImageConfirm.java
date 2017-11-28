package com.tmaat.dtara.onlinemovingestimator;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Canvas;
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
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;

public class ImageConfirm extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_image_confirm);
        ProgressBar progress = (ProgressBar) findViewById(R.id.progress);
        progress.setVisibility(View.GONE);
        displayListView();
    }

    ImageConfirm.MyCustomAdapter dataAdapter = null;

    private void displayListView() {

        //Array list of images
        ArrayList<Image> imgList = MainActivity.est.getImageList();
        ListView listView = (ListView) findViewById(R.id.imgList);

        // If the array list of images is not empty
        if (imgList.size() != 0) {
            //create an ArrayAdaptar from the String Array
            dataAdapter = new ImageConfirm.MyCustomAdapter(this,
                    R.layout.activity_img_catalog, imgList);
            // Assign adapter to ListView
            listView.setAdapter(dataAdapter);

            // Set a listener on the list view
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                public void onItemClick(AdapterView<?> parent, View view,
                                        int position, long id) {
                    // When clicked, start an intent with the image information passed
                    Image img = (Image) parent.getItemAtPosition(position);
                    Intent intent = new Intent(ImageConfirm.this, FurnConfirm.class);
                    intent.putExtra("ImageNum",img.getNumber());
                    startActivity(intent);
                }
            });
        } else {
            // Hide the list view if no images available
            listView.setVisibility(View.GONE);
            RelativeLayout rl = (RelativeLayout) findViewById(R.id.imgConfirm);
            TextView txt = new TextView(this);
            // Display "no images found" text
            txt.setText("No Images Found");
            rl.addView(txt);
        }

    }

    private class MyCustomAdapter extends ArrayAdapter<Image> {
    // Define Adapter class

        private ArrayList<Image> imgList;

        public MyCustomAdapter(Context context, int textViewResourceId,
                               ArrayList<Image> imgList) {
            super(context, textViewResourceId, imgList);
            this.imgList = new ArrayList<Image>();
            this.imgList.addAll(imgList);
        }

        // Components for image row
        private class ViewHolder {
            TextView name;
            TextView room_status;
            Button button;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {

            ImageConfirm.MyCustomAdapter.ViewHolder holder = null;

            if (convertView == null) {
                LayoutInflater vi = (LayoutInflater)getSystemService(
                        Context.LAYOUT_INFLATER_SERVICE);
                convertView = vi.inflate(R.layout.activity_img_catalog, null);

                holder = new ImageConfirm.MyCustomAdapter.ViewHolder();
                holder.name = (TextView) convertView.findViewById(R.id.imgText);
                holder.room_status = (TextView) convertView.findViewById(R.id.roomStatus);
                holder.button = (Button) convertView.findViewById(R.id.proceed);
                convertView.setTag(holder);

                // If user clicks on button
                holder.button.setOnClickListener( new View.OnClickListener() {
                    public void onClick(View v) {
                        Button cb = (Button) v ;
                        Image im = (Image) cb.getTag();
                        // Go to furniture confirm page with image information
                        Intent intent = new Intent(ImageConfirm.this, FurnConfirm.class);
                        intent.putExtra("ImageNum",im.getNumber());
                        startActivity(intent);
                    }
                });
            }
            else {
                holder = (ImageConfirm.MyCustomAdapter.ViewHolder) convertView.getTag();
            }

            // Initialize the rows with information
            Image img = imgList.get(position);
            holder.name.setText("Image No."+img.getNumber());
            holder.name.setTag(img);
            holder.button.setTag(img);
            if (img.loading) {
                // If the image is loading, don't display button or room
                holder.room_status.setText("Loading");
                holder.button.setVisibility(View.GONE);
            } else {
                holder.room_status.setText(img.getRoom());
            }
            return convertView;
        }
    }

    public void onRoomChange(View view) {
        Intent intent = new Intent(this, Pop.class);
        startActivity(intent);
    }

    public void onTakeImage(View view) {
        Intent intent = new Intent(this, camera.class);
        startActivity(intent);
    }

    public void onFinish(View view) {
        updateFurnList();
        final View view_final = view;

        new Thread(new Runnable() {

            @Override
            public void run() {

                Cloud cloud = new Cloud();
                final boolean ok = cloud.FurnitureUpload(view_final.getContext());
                if (!ok) {
                    /*
                     * If we fail to save, display a toast
                     */
                    // Please fill this in...
                    view_final.post(new Runnable() {

                        @Override
                        public void run() {
                            Toast.makeText(getApplicationContext(),
                                    "Failed to upload furniture.", Toast.LENGTH_LONG).show();
                        }
                    });
                } else {
                    view_final.post(new Runnable() {

                        @Override
                        public void run() {
                            ProgressBar progress = (ProgressBar) findViewById(R.id.progress);
                            progress.setVisibility(View.VISIBLE);
                        }
                    });
                }
            }
        }).start();
    }

    private void updateFurnList() {
        ArrayList<Image> imgList = MainActivity.est.getImageList();
        if (imgList.size() != 0)
        for (Image i: imgList) {
            i.updateFurnList();
        }
    }
}
