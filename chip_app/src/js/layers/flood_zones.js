"use strict";

import {Image as ImageLayer} from 'ol/layer';
import Dynamic from "ol/source/ImageArcGISRest";


/**
 * Image Layer functions
 **/

 export function layer(map) {
   
  let customParams = {};
  customParams["LAYERS"] = "show:0";
  let url = process.env.ELM_APP_AGS_FZ_URL;

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
    dynamicLayer.set("name", "flood_zone");
    dynamicLayer.setOpacity(0.7);
    map.on("render_fz", ({data}) => {
      dynamicLayer.setVisible(true)
  });

  map.on("disable_fz", () => {
      dynamicLayer.setVisible(false)
  });
  return dynamicLayer;
  
}