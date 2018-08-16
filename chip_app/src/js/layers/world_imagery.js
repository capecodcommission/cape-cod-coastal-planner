"use strict";

import TileLayer from "ol/layer/tile";
import XYZ from "ol/source/xyz";

export function layer() {
    let source = _source();

    let layer = new TileLayer({
        visible: true,
        preload: 4,
        source: source
    });
    return layer;
}

function _source() {
    let url = process.env.ELM_APP_AGS_WORLD_IMG_URL;
    if (!url) {
        throw Error("Must configure environment variable `ELM_APP_AGS_WORLD_IMG_URL`!");
    }
    let source = new XYZ({
        crossOrigin: "anonymous",
        url: url,
        maxZoom: 16,
        minZoom: 3,
        tileLoadFunction: (imageTile, src) => {
            imageTile.getImage().src = src;
        }
    });
    return source;
}