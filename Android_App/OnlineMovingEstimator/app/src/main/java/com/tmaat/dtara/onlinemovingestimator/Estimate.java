package com.tmaat.dtara.onlinemovingestimator;

import android.util.Log;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Estimate {
    String id = null;
    String room = null;
    ArrayList<Image> imageList = new ArrayList<Image>();
    int imageNumber = 0;
    ArrayList<Furniture> furnitureList = new ArrayList<Furniture>();
    ArrayList<Furniture> tempFurnList = new ArrayList<Furniture>();
    String[] RoomList = {"Bedroom","Garage","Living Room","Dining Room","Kitchen","Office","Patio",
            "Business Office","Business File Room","Business Copy Room","Business Reception Area"};
    public static Map<String, Integer> roomID = new HashMap<String, Integer>();
    Map<String,ArrayList<Furniture>> roomFurnList= new HashMap<String,ArrayList<Furniture>>();

    public Estimate(String id) {
        super();
        this.id = id;
        initializeRoomID();
    }

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

    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }

    public ArrayList<Furniture> getTotalList() {
        return furnitureList;
    }
    public void addToTotalList() {
        updateTempList(); furnitureList.addAll(tempFurnList); tempFurnList.clear();
    }

    public void updateTempList() {
        ArrayList<Furniture> loopList = new ArrayList<Furniture>();
        for (Furniture f: tempFurnList) {
            if (!f.isSelected()) {
                loopList.add(f);
            }
        }
        tempFurnList.removeAll(loopList);
    }

    public void addCurrentRoom(String r) {room = r;}

    public void updateRoomList() {
        ArrayList<Furniture> newList;
        for (Image i: imageList) {
            if (roomFurnList.containsKey(i.getRoom())) {
                newList = roomFurnList.get(i.getRoom());
                roomFurnList.remove(i.getRoom());
            } else {
                newList = new ArrayList<Furniture>();
            }
            for (Furniture f: i.getFurnList()) {
                if (!withinArray(newList, f)) {
                    f.incrementNumOfFurn();
                    newList.add(f);
                } else {
                    Furniture ff = newList.get(indexArray(newList, f));
                    ff.incrementNumOfFurn();
                }
            }
            if (newList.size() > 0) {
                roomFurnList.put(i.getRoom(),newList);
            }
        }
    }

    public boolean withinArray(ArrayList<Furniture> newList, Furniture f) {
        for (Furniture newFurn: newList) {
            if (newFurn.getName().equals(f.getName())) {
                return true;
            }
        }
        return false;
    }

    public int indexArray(ArrayList<Furniture> newList, Furniture f) {
        int index = 0;
        for (Furniture newFurn: newList) {
            if (newFurn.getName().equals(f.getName())) {
                return index;
            }
            index++;
        }
        return -1;
    }

    public int nextAvailableImageNumber() {
        imageNumber = imageNumber + 1;
        return imageNumber;
    }

    public void removeImage(int imgNum) {
        ArrayList<Image> tempImageList = new ArrayList<Image>(imageList);
        for (Image i: tempImageList) {
            if (i.getNumber() == imgNum) {
                imageList.remove(i);
                break;
            }
        }
    }

    public ArrayList<Image> getImageList() { return imageList; }
    public void addToImageList(Image img) {imageList.add(img);}

    public Image getImage(int imageNumber) {
        for (Image i: imageList) {
            if (imageNumber == i.getNumber()) {
                return i;
            }
        }
        return imageList.get(0);
    }
}
