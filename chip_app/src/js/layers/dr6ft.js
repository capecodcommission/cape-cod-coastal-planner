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
    layer.set("name", "disconnected_roads_6ft");

    map.on("render_dr6ft", ({data}) => {
        layer.setVisible(true);
    });

    map.on("disable_dr6ft", () => {
        layer.setVisible(false);
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
        url: 'http://gis-services.capecodcommission.org/arcgis/rest/services/SeaLevelRise/Roads_Isolated_6ft/MapServer/tile/{z}/{y}/{x}',
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