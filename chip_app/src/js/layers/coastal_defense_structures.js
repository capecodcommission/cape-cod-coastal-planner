"use strict";

import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import Style from "ol/style/Style";
import Stroke from "ol/style/Stroke";
import Fill from "ol/style/Fill";
import Circle from "ol/style/Circle";
import {getCoastalColors} from "../misc.js";


/**
 * Vector Layer functions
 */

export function layer(map) {
    let source = new VectorSource({
        url: process.env.ELM_APP_AGS_CDS_URL,
        format: new EsriJSON()
    });

    let layer = new VectorLayer({
        visible: false,
        source: source,
        style: (feature, resolution) => {
            return new Style({
                fill: new Fill({
                  color: getCoastalColors(feature)
                })
            });
        }
    });
    layer.set("name", "coastal_defense_structures");

    map.on("render_cds", ({data}) => {
        layer.setVisible(true)
    });

    map.on("disable_cds", () => {
        layer.setVisible(false)
    });

    return layer;
}