"use strict";

import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import Style from "ol/style/Style";
import Stroke from "ol/style/Stroke";
import Fill from "ol/style/Fill";
import Circle from "ol/style/Circle";

const esrijsonformat = new EsriJSON();

/**
 * Vector Layer functions
 */

export function layer(map) {
    let source = new VectorSource();

    let layer = new VectorLayer({
        visible: false,
        source: source,
        style: (feature, resolution) => {
            return new Style({
                fill: new Fill({
                  color: [244, 188, 66, 1]
                })
            });
        }
    });
    layer.set("name", "municipally_owned_parcels");

    map.on("render_mop", ({data}) => {
        onRenderMOP(data, layer, source);
    });

    map.on("disable_mop", () => {
        disableMOP(layer, source);
    });

    return layer;
}

function onRenderMOP(data, layer, source) {
    // decode esri json to ol features
    let features = esrijsonformat.readFeaturesFromObject(data.response);
    
    source.addFeatures(features);
    layer.setVisible(true);
}

function disableMOP(layer, source) {
    // decode esri json to ol features
    // let features = esrijsonformat.readFeaturesFromObject(data.response);
    
    // source.addFeatures(features);
    layer.setVisible(false);
}