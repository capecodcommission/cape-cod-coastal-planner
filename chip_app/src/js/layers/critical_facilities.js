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
    let source = new VectorSource({
        url: process.env.ELM_APP_AGS_CRITTOGGLE_URL,
        format: new EsriJSON()
    });

    let layer = new VectorLayer({
        visible: false,
        source: source,
        style: (feature, resolution) => {
            return new Style({
                image: new Circle({
                    radius: 3,
                    fill: new Fill({color: 'orange'}),
                    stroke: new Stroke({
                        color: [244, 167, 66],
                        width: 2
                    })
                })
            });
        }
    });
    layer.set("name", "critical_facilities");

    map.on("render_critical_facilities", ({data}) => {
        layer.setVisible(true);
    });

    map.on("disable_critical_facilities", () => {
        layer.setVisible(false);
    });

    return layer;
}