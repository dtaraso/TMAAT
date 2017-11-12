package com.tmaat.dtara.onlinemovingestimator;

import android.util.Log;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Estimate {
    String id = null;
    ArrayList<Furniture> furnitureList = new ArrayList<Furniture>();
    ArrayList<Furniture> tempFurnList = new ArrayList<Furniture>();
    String[] RoomList = {"Bedroom","Garage","Living Room","Dining Room","Kitchen","Office","Patio",
            "Business Office","Business File Room","Business Copy Room","Business Reception Area"};
    public static Map<String, Integer> roomID = new HashMap<String, Integer>();
    Map<String,ArrayList<Furniture>> roomFurnList= new HashMap<String,ArrayList<Furniture>>();
    String room = null;

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
        updateTempList(); /*updateRoomList();*/ furnitureList.addAll(tempFurnList); tempFurnList.clear();
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

    public ArrayList<Furniture> getTempList() { return tempFurnList; }
    public void addToTempList(Furniture furn) {tempFurnList.add(furn); }
    public void resetTempList() {tempFurnList.clear();}

    public void addCurrentRoom(String r) {room = r;}

    public void updateRoomList() {
        ArrayList<Furniture> newList;
        for (String r: RoomList) {
            if (roomFurnList.containsKey(r)) {
                newList = roomFurnList.get(r);
                roomFurnList.remove(room);
            } else {
                newList = new ArrayList<Furniture>();
            }
            for (Furniture f : furnitureList) {
                if (f.getRoom().equals(r)) {
                    if (!withinArray(newList, f)) {
                        f.incrementNumOfFurn();
                        newList.add(f);
                    } else {
                        Furniture ff = newList.get(indexArray(newList, f));
                        ff.incrementNumOfFurn();
                    }
                }
            }
            if (newList.size() > 0) {
                roomFurnList.put(r, newList);
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
}
