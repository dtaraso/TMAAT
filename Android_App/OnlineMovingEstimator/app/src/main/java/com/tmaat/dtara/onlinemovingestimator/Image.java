package com.tmaat.dtara.onlinemovingestimator;

import java.util.ArrayList;

/**
 * Created by dtara on 11/17/2017.
 */

public class Image {
    // Image Number -- identifier
    int number = 0;
    // Arraylist of ImageResponses -- response from image upload
    ArrayList<ImageResponse> imageArray = new ArrayList<ImageResponse>();
    // Arraylist of Furniture -- similar to imageArray
    ArrayList<Furniture> furnList = new ArrayList<Furniture>();
    // Room the image was taken in
    String room = "";
    // Whether the image is still loading or not
    boolean loading = true;

    // Constructor
    public Image(int number, String room) {
        super();
        this.number = number;
        this.room = room;
    }

    // Getter for number attribute
    public int getNumber() { return number; }

    // Getter for room attribute
    public String getRoom() { return room; }

    // Setter for image array
    public void setImageArray(ArrayList<ImageResponse> imgArray) {this.imageArray = imgArray;}

    // Getter for Furniture List
    public ArrayList<Furniture> getFurnList() { ImageToFurn(); return furnList; }
    // Add an individual piece of furniture to the arraylist
    public void AddToFurnList(Furniture f) { furnList.add(f); }

    // Setter for the loading boolean
    public void setLoading(boolean input) { this.loading = input;}

    // Convert the image responses in imageArray to furniture and place in the Furniture List
    public void ImageToFurn() {
        // Check that the image array is not empty and we have not converted the list to furniture YET
        if (imageArray.size() != 0 && furnList.size() == 0) {
            for (ImageResponse i : imageArray) {
                String str = i.generic;
                String cap = str.substring(0, 1).toUpperCase() + str.substring(1);
                // Initialize the furniture object
                Furniture furn = new Furniture(cap, i.id, true, MainActivity.est.room, i.relatedInCategory);
                // Append to the furnlist
                furnList.add(furn);
            }
        }
    }

    // Checks if furniture has been unselected and removes from the official furniture list
    public void updateFurnList() {
        ArrayList<Furniture> tempFurnList = new ArrayList<Furniture>(furnList);
        for (Furniture f: tempFurnList) {
            if (f.selected == false) {
                furnList.remove(f);
            }
        }
    }
}
