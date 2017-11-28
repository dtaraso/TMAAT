package com.tmaat.dtara.onlinemovingestimator;

import java.util.ArrayList;

/**
 * Created by dtara on 10/11/2017.
 */

public class ImageResponse {
    // JSON Response from Image Upload/ Get Items requests

    /*
    Commented attributes are included in json response but not being currently used
     */

    /*
    public String item;
    public String category;
    public ArrayList<String> related;
    */
    public String id;
    public String name;
    public String generic;
    public ArrayList<String> relatedInCategory;

}
