package com.tmaat.dtara.onlinemovingestimator;

import java.util.ArrayList;

/**
 * Created by dtara on 11/17/2017.
 */

public class Image {
    int number = 0;
    ArrayList<ImageResponse> imageArray = new ArrayList<ImageResponse>();
    ArrayList<Furniture> furnList = new ArrayList<Furniture>();
    String room = "";
    boolean loading = true;

    public Image(int number, String room) {
        super();
        this.number = number;
        this.room = room;
    }

    public int getNumber() { return number; }

    public String getRoom() { return room; }

    public void setImageArray(ArrayList<ImageResponse> imgArray) {this.imageArray = imgArray;}

    public ArrayList<Furniture> getFurnList() { ImageToFurn(); return furnList; }
    public void AddToFurnList(Furniture f) { furnList.add(f); }

    public void setLoading(boolean input) { this.loading = input;}

    public void ImageToFurn() {
        if (imageArray.size() != 0 && furnList.size() == 0) {
            for (ImageResponse i : imageArray) {
                String str = i.generic;
                String cap = str.substring(0, 1).toUpperCase() + str.substring(1);
                Furniture furn = new Furniture(cap, i.id, true, MainActivity.est.room, i.relatedInCategory);
                furnList.add(furn);
            }
        }
    }

    public void updateFurnList() {
        ArrayList<Furniture> tempFurnList = new ArrayList<Furniture>(furnList);
        for (Furniture f: tempFurnList) {
            if (f.selected == false) {
                furnList.remove(f);
            }
        }
    }
}
