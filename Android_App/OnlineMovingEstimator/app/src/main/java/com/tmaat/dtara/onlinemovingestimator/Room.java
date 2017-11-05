package com.tmaat.dtara.onlinemovingestimator;

import java.util.ArrayList;

/**
 * Created by dtara on 11/1/2017.
 */

public class Room {
    ArrayList<Furniture> furnList;
    String id = null;
    String name = null;

    public Room(String name, String id) {
        super();
        this.name = name;
        this.id = id;
    }

    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }

    public ArrayList<Furniture> getList() {
        return furnList;
    }
    public void addToList(ArrayList<Furniture> tempFurnList) {
        furnList.addAll(tempFurnList);
    }
}
