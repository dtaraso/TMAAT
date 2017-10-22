package com.tmaat.dtara.onlinemovingestimator;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by dtara on 9/24/2017.
 */

public class Furniture {
    String name = null;
    String room = null;
    ArrayList<String> quantity = new ArrayList<String>();
    boolean selected = true;

    public Furniture(String name, boolean selected, String room, ArrayList<String> quantity) {
        super();
        this.name = name;
        this.selected = selected;
        this.room = room;
        this.quantity = quantity;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public boolean isSelected() {
        return selected;
    }
    public void setSelected(boolean selected) {
        this.selected = selected;
    }
}
