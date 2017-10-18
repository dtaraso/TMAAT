package com.tmaat.dtara.onlinemovingestimator;

/**
 * Created by dtara on 9/24/2017.
 */

public class Furniture {
    String name = null;
    String room = null;
    int quantity = 0;
    boolean selected = false;

    public Furniture(String name, boolean selected, String room, int quantity) {
        super();
        this.name = name;
        this.selected = selected;
        this.room = room;
        this.quantity = quantity + 1;
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
