"use strict";

import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import Style from "ol/style/Style";
import Stroke from "ol/style/Stroke";
import Fill from "ol/style/Fill";
import Circle from "ol/style/Circle";
import RegularShape from "ol/style/RegularShape";

const esrijsonformat = new EsriJSON();

/**
 * Vector Layer functions
 */

export function layer(map) {
    let source = new VectorSource({
        // url: process.env.ELM_APP_AGS_PATHWAYS_POINT_URL,
        format: new EsriJSON()
    });

    let layer = new VectorLayer({
        visible: false,
        source: source,
        style: (feature, resolution) => {
            let circleStyle =  new Style({
                image: new Circle({
                    radius: 3,
                    fill: new Fill({color: 'blue'}),
                    stroke: new Stroke({
                        color: [7, 7, 112],
                        width: 2
                    })
                })
            });
            let triangleStyle = new Style({
                image: new RegularShape({
                  fill: new Fill({color: [38,20,20,1]}),
                  stroke: new Stroke({
                    color: [129,64,64,1],
                    width: 1
                  }),
                  points: 3,
                  radius: 7,
                //   rotation: Math.PI / 4,
                  angle: 0,
                }),
              });
              return triangleStyle;
        }
    });
    layer.set("name", "stormtide_pathways_points");

    map.on("stormtide_pathways_points_loaded", ({data}) => {
        let features = esrijsonformat.readFeaturesFromObject(data.response);        
        source.clear();
        if (features.length > 0) {
            source.addFeatures(features);
        }
        layer.setVisible(true);
    });

    map.on("disable_stormtide_pathways_points", () => {
        source.clear();
        layer.setVisible(false);
    });

    return layer;
}