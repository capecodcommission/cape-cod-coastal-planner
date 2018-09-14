"use strict";

import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import Style from "ol/style/Style";
import Fill from "ol/style/Fill";
import Stroke from "ol/style/Stroke";

const esrijsonformat = new EsriJSON();

/**
 * Vector Layer functions
 */

export function layer(map) {
    let source = new VectorSource();

    let layer = new VectorLayer({
        visible: false,
        source: source,
        style: _style
    });
    layer.set("name", "location_hexes");

    map.on("render_location_hexes", ({data}) => {
        onRenderLocationHexes(data, layer, source);
    });

    return layer;
}


function onRenderLocationHexes(data, layer, source) {
    // decode esri json to ol features
    let features = esrijsonformat.readFeaturesFromObject(data.response);
    if (features.length === 0) {
        source.clear();
        layer.setVisible(false);
    } else {
        source.addFeatures(features);
        layer.setVisible(true);
    }
}


/**
 * Vector Style functions
 */


function _style(feature, resolution) {
    return new Style({
        fill: new Fill({
            color: "rgba(226,6,44,0.2)"
        }),
        stroke: new Stroke({
            color: "#E2062C",
            width: 1
        })
    });
 }