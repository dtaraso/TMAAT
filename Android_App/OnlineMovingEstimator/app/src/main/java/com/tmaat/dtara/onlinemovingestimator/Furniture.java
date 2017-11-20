package com.tmaat.dtara.onlinemovingestimator;

import java.util.ArrayList;

public class Furniture {
    String name = null;
    String room = null;
    String ID = null;
    ArrayList<String> quantity = new ArrayList<String>();
    boolean selected = true;
    int numOfFurn = 0;

    public Furniture(String name, String id) {
        super();
        this.name = name;
        this.ID = id;
        this.room = MainActivity.est.room;
    }

    public Furniture(String name, String id, boolean selected, String room, ArrayList<String> quantity) {
        super();
        this.name = name;
        this.ID = id;
        this.selected = selected;
        this.room = room;
        this.quantity = quantity;
        this.quantity.add(id);
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public void setID(String id) { this.ID = id;}
    public String getID() { return this.ID; }

    public boolean isSelected() {
        return selected;
    }
    public void setSelected(boolean selected) {
        this.selected = selected;
    }

    public int getNumOfFurn() {return numOfFurn;}
    public void incrementNumOfFurn() {numOfFurn = numOfFurn+1;}

    public String getRoom() {return room;}
}
