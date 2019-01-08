"use strict";

import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import Style from "ol/style/Style";
import Stroke from "ol/style/Stroke";
import Fill from "ol/style/Fill";
import Circle from "ol/style/Circle";

/**
 * Vector Layer functions
 */

export function layer(map) {
    let source = new VectorSource({
        url: process.env.ELM_APP_AGS_STRUCTURES_URL,
        format: new EsriJSON()
    });

    let layer = new VectorLayer({
        visible: false,
        source: source,
        style: (feature, resolution) => {
            return new Style({
                fill: new Fill({
                  color: [156, 156, 156, .7]
                })
            });
        }
    });
    layer.set("name", "structures");

    map.on("render_struct", ({data}) => {
        layer.setVisible(true)
    });

    map.on("disable_struct", () => {
        layer.setVisible(false)
    });

    return layer;
}