package com.tmaat.dtara.onlinemovingestimator;

import java.util.ArrayList;

public class Furniture {
    // Furniture name
    String name = null;
    // Room the furniture was found in
    String room = null;
    // Furniture ID
    String ID = null;
    // List of IDs that are related to this furniture (e.x. Bed -> Queen Bed, King Bed)
    ArrayList<String> quantity = new ArrayList<String>();
    // Boolean on whether user selected or unselected
    boolean selected = true;
    // Number of furniture within the room
    int numOfFurn = 0;

    // Constructor when user adds in this item manually
    public Furniture(String name, String id) {
        super();
        this.name = name;
        this.ID = id;
        this.room = MainActivity.est.room;
    }

    // Constructor when identified in images
    public Furniture(String name, String id, boolean selected, String room, ArrayList<String> quantity) {
        super();
        this.name = name;
        this.ID = id;
        this.selected = selected;
        this.room = room;
        this.quantity = quantity;
        this.quantity.add(id);
    }

    // Getter/Setter for name attribute
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    // Getter/Setter for ID attribute
    public void setID(String id) { this.ID = id;}
    public String getID() { return this.ID; }

    // Getter/Setter for selected attribute
    public boolean isSelected() {
        return selected;
    }
    public void setSelected(boolean selected) {
        this.selected = selected;
    }

    // Getter for number of furniture attribute
    public int getNumOfFurn() {return numOfFurn;}
    // Increment the number of furniture
    public void incrementNumOfFurn() {numOfFurn = numOfFurn+1;}
}
