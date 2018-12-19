"use strict";

import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import Style from "ol/style/Style";
import Stroke from "ol/style/Stroke";
import Fill from "ol/style/Fill";
import Circle from "ol/style/Circle";
import Icon from "ol/style/Icon"
import {getSTIRotation} from '../misc'


/**
 * Vector Layer functions
 */

export function layer(map) {
    let source = new VectorSource({
        url: process.env.ELM_APP_AGS_STI_URL,
        format: new EsriJSON()
    });

    let layer = new VectorLayer({
        visible: false,
        source: source,
        style: (feature, resolution) => {
            return new Style({
                image: new Icon({
                    src: 'http://www.clker.com/cliparts/B/y/m/z/O/r/orange-arrow-md.png',
                    scale: .08,
                    rotation: getSTIRotation(feature),
                })
            });
        }
    });
    layer.set("name", "sediment_transport_indicators");

    map.on("render_sti", ({data}) => {
        layer.setVisible(true);
    });

    map.on("disable_sti", () => {
        layer.setVisible(false);
    });

    return layer;
}