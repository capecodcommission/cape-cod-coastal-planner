"use strict";

import {Image as ImageLayer} from 'ol/layer';
import Dynamic from "ol/source/ImageArcGISRest";


/**
 * Image Layer functions
 **/

 export function layer(map) {
   
  let customParams = {};
  customParams["LAYERS"] = "show:12";
  let url = process.env.ELM_APP_AGS_DR_FOUR;

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
    dynamicLayer.set("name", "disconnected_roads_4ft");
    dynamicLayer.setOpacity(0.7);
    map.on("render_dr4ft", ({data}) => {
      dynamicLayer.setVisible(true)
  });

  map.on("disable_dr4ft", () => {
      dynamicLayer.setVisible(false)
  });
  return dynamicLayer;
  
}