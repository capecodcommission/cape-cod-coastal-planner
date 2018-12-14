"use strict";

import TileLayer from "ol/layer/Tile";
import XYZ from "ol/source/XYZ";

export function layer(map) {
    let source = _source();

    let layer = new TileLayer({
        visible: false,
        preload: 4,
        opacity: 0.5,
        source: source
    });
    layer.set("name", "flood_zone");

    map.on("render_fz", ({data}) => {
      onRenderFZ(data, layer, source);
    });

    map.on("disable_fz", () => {
      disableFZ(layer, source);
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
        url: 'http://gis-services.capecodcommission.org/arcgis/rest/services/Web_Basedata/FEMA_FIRM_2013/MapServer/tile/{z}/{y}/{x}',
        maxZoom: 16,
        minZoom: 3,
        opaque: false,
        transition: 4,
        tileLoadFunction: (imageTile, src) => {
            imageTile.getImage().src = src;
        }
    });
    return source;
}

function onRenderFZ(data, layer, source) {
  // decode esri json to ol features
  // let features = esrijsonformat.readFeaturesFromObject(data.response);
  
  // source.addFeatures(features);
  layer.setVisible(true);
}

function disableFZ(layer, source) {
  // decode esri json to ol features
  // let features = esrijsonformat.readFeaturesFromObject(data.response);
  
  // source.addFeatures(features);
  layer.setVisible(false);
}