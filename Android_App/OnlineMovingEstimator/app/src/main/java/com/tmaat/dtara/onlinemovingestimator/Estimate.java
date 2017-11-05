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

    public ArrayList<Furniture> getTempList() { return tempFurnList; }
    public void addToTempList(Furniture furn) {tempFurnList.add(furn); }
    public void resetTempList() {tempFurnList.clear();}

    public void addCurrentRoom(String r) {room = r;}
}
