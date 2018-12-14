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
    layer.set("name", "sea_level_rise_5ft");

    map.on("render_slr5ft", ({data}) => {
      onRenderSLR(data, layer, source);
    });

    map.on("disable_slr5ft", () => {
      disableSLR(layer, source);
    });

    return layer;
}

function _source() {
    // let url = process.env.ELM_APP_AGS_SLR_TWO;
    // if (!url) {
    //     throw Error("Must configure environment variable `ELM_APP_AGS_WORLD_SLR_TWO`!");
    // }
    let source = new XYZ({
        crossOrigin: "anonymous",
        url: 'http://gis-services.capecodcommission.org/arcgis/rest/services/SeaLevelRise/SLR_5ft_Corrected/MapServer/tile/{z}/{y}/{x}',
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

function onRenderSLR(data, layer, source) {
  // decode esri json to ol features
  // let features = esrijsonformat.readFeaturesFromObject(data.response);
  
  // source.addFeatures(features);
  layer.setVisible(true);
}

function disableSLR(layer, source) {
  // decode esri json to ol features
  // let features = esrijsonformat.readFeaturesFromObject(data.response);
  
  // source.addFeatures(features);
  layer.setVisible(false);
}