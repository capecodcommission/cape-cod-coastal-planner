"use strict";

//import {getLowLyingRoadsColors} from "../misc.js";

import {Image as ImageLayer} from 'ol/layer';
import Dynamic from "ol/source/ImageArcGISRest";


/**
 * Image Layer functions
 **/

export function layer(map) {
   
    let customParams = {};
    customParams["LAYERS"] = "show:9";
    let url = process.env.ELM_APP_AGS_LLR_URL;

    let dynamicLayer = new ImageLayer({
        visible: false,
        source: new Dynamic({
          crossOrigin: "anonymous",
          ratio: 1,
          params: customParams,
          url: url,
          imageLoadFunction: (image, src) => {
            image.getImage().src = src;
          }
        })
      });
      dynamicLayer.set("name", "low_lying_roads");
      map.on("render_llr", ({data}) => {
        dynamicLayer.setVisible(true)
    });

    map.on("disable_llr", () => {
        dynamicLayer.setVisible(false)
    });
    return dynamicLayer;
    
}