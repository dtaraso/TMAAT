package com.tmaat.dtara.onlinemovingestimator;

import java.util.ArrayList;

public class Estimate {
    String id = null;
    ArrayList<Furniture> furnitureList = new ArrayList<Furniture>();
    ArrayList<Furniture> tempFurnList = new ArrayList<Furniture>();
    String room = null;

    public Estimate(String id) {
        super();
        this.id = id;
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
        furnitureList.addAll(tempFurnList); tempFurnList.clear();
    }

    public ArrayList<Furniture> getTempList() { return tempFurnList; }
    public void addToTempList(Furniture furn) {tempFurnList.add(furn); }
    public void resetTempList() {tempFurnList.clear();}

    public void removeFromTempList(int index) {tempFurnList.remove(index);}

    public void addCurrentRoom(String r) {room = r;}
}
