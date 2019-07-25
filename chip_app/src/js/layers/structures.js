"use strict";

import TileLayer from "ol/layer/Tile";
import XYZ from "ol/source/XYZ";

export function layer(map) {
    let source = _source();

    let layer = new TileLayer({
        visible: false,
        preload: 4,
        opacity: 1,
        source: source
    });
    layer.set("name", "structures");

    map.on("render_struct", ({data}) => {
      renderStruct(data, layer, source);
    });

    map.on("disable_struct", () => {
      disableStruct(layer, source);
    });

    return layer;
}

function _source() {
    // let url = process.env.ELM_APP_AGS_SLR_URL;
    // if (!url) {
    //     throw Error("Must configure environment variable `ELM_APP_AGS_WORLD_IMG_URL`!");
    // }
    let source = new XYZ({
        crossOrigin: "anonymous",
        url: process.env.ELM_APP_AGS_STRUCTURES_URL,
        maxZoom: 16,
        minZoom: 3,
        opaque: true,
        transition: 4
    });
    return source;
}

function renderStruct(data, layer, source) {
  // decode esri json to ol features
  // let features = esrijsonformat.readFeaturesFromObject(data.response);
  
  // source.addFeatures(features);
  layer.setVisible(true);
}

function disableStruct(layer, source) {
  // decode esri json to ol features
  // let features = esrijsonformat.readFeaturesFromObject(data.response);
  
  // source.addFeatures(features);
  layer.setVisible(false);
}