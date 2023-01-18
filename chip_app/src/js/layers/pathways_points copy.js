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
        url: process.env.ELM_APP_AGS_PATHWAYS_POINT_URL,
        format: new EsriJSON()
    });

    let layer = new VectorLayer({
        visible: false,
        source: source,
        style: (feature, resolution) => {
            return new Style({
                image: new Circle({
                    radius: 3,
                    fill: new Fill({color: 'blue'}),
                    stroke: new Stroke({
                        color: [7, 7, 112],
                        width: 2
                    })
                })
            });
        }
    });
    layer.set("name", "stormtide_pathways_points");

    map.on("render_stormtide_pathways_points", ({data}) => {
        layer.setVisible(true);
    });

    map.on("disable_stormtide_pathways_points", () => {
        layer.setVisible(false);
    });

    return layer;
}