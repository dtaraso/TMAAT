package com.tmaat.dtara.onlinemovingestimator;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Estimate {
    // Estimate id initialized in Main Activity
    String id = null;
    // Current room
    String room = null;
    // List of image objects
    ArrayList<Image> imageList = new ArrayList<Image>();
    // Current image number
    int imageNumber = 0;
    // Dictionary with room string as key and its associated ID as the value
    public static Map<String, Integer> roomID = new HashMap<String, Integer>();
    // Dictionary with room string as key and the furniture in the room
    Map<String,ArrayList<Furniture>> roomFurnList= new HashMap<String,ArrayList<Furniture>>();

    // Constructor
    public Estimate(String id) {
        super();
        this.id = id;
        initializeRoomID();
    }

    // Place data within the roomID
    public void initializeRoomID() {
        roomID.put("Bedroom", 1);
        roomID.put("Garage", 4);
        roomID.put("Living Room", 3);
        roomID.put("Dining Room", 8);
        roomID.put("Kitchen", 2);
        roomID.put("Office", 9);
        roomID.put("Patio", 17);
        roomID.put("Business Office", 12);
        roomID.put("Business File Room", 13);
        roomID.put("Business Copy Room", 21);
        roomID.put("Business Reception Area", 22);
    }

    // Getter/Setter for ID attribute
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }

    // Setter for room attribute
    public void addCurrentRoom(String r) {room = r;}

    // Update the furniture quantity in each room
    public void updateRoomList() {
        ArrayList<Furniture> newList;
        // For each image
        for (Image i: imageList) {
            // If room already has furniture within it
            if (roomFurnList.containsKey(i.getRoom())) {
                // Get the current list
                newList = roomFurnList.get(i.getRoom());
                // Remove the current list from the official list
                roomFurnList.remove(i.getRoom());
            } else {
                // Create an empty list
                newList = new ArrayList<Furniture>();
            }
            // Loop through the furniture list within the image
            for (Furniture f: i.getFurnList()) {
                // If the furniture object is not within the list
                if (!withinArray(newList, f)) {
                    // Set the quantity of the furniture to 1
                    f.incrementNumOfFurn();
                    // Add to the furniture list
                    newList.add(f);
                } else {
                    // If furniture is within list, get the furniture object
                    Furniture ff = newList.get(indexArray(newList, f));
                    // increment the quantity
                    ff.incrementNumOfFurn();
                }
            }
            // If the list is not empty
            if (newList.size() > 0) {
                // Place the pair of the room and list of furniture into the official roomFurnList
                roomFurnList.put(i.getRoom(),newList);
            }
        }
    }

    // Checks if Furniture object with same name is already within the room list
    public boolean withinArray(ArrayList<Furniture> newList, Furniture f) {
        for (Furniture newFurn: newList) {
            // If the furniture name matches the object in the list
            if (newFurn.getName().equals(f.getName())) {
                return true;
            }
        }
        // Object is not in the list
        return false;
    }

    // Returns the index of the furniture within the list
    public int indexArray(ArrayList<Furniture> newList, Furniture f) {
        int index = 0;
        for (Furniture newFurn: newList) {
            // If the furniture name matches the object in the list
            if (newFurn.getName().equals(f.getName())) {
                return index;
            }
            index++;
        }
        return -1;
    }

    // Returns the next available number to use as an ID for an Image
    public int nextAvailableImageNumber() {
        imageNumber = imageNumber + 1;
        return imageNumber;
    }

    // Removes image from the Image List using the Image ID
    public void removeImage(int imgNum) {
        // Create a temporary copy of the image list
        ArrayList<Image> tempImageList = new ArrayList<Image>(imageList);
        for (Image i: tempImageList) {
            // If the image number matches the function parameter
            if (i.getNumber() == imgNum) {
                // Remove the image from the official list
                imageList.remove(i);
                // Break out of the loop
                break;
            }
        }
    }

    // Getter for the image list
    public ArrayList<Image> getImageList() { return imageList; }
    // Add an Image object to the image list
    public void addToImageList(Image img) {imageList.add(img);}

    // Returns the image from the image list using the image ID
    public Image getImage(int imageNumber) {
        for (Image i: imageList) {
            if (imageNumber == i.getNumber()) {
                // Return the image if image numbers match
                return i;
            }
        }
        return imageList.get(0);
    }
}
