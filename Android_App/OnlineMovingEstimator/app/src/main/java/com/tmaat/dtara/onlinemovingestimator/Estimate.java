package com.tmaat.dtara.onlinemovingestimator;

import java.util.ArrayList;

public class Estimate {
    String id = null;
    ArrayList<Furniture> furnitureList;

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

    public ArrayList<Furniture> getList() {
        return furnitureList;
    }
    public void addToList(Furniture furn) {
        furnitureList.add(furn);
    }
}
