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
    let source = new XYZ({
        crossOrigin: "anonymous",
        url: "https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
        maxZoom: 16,
        minZoom: 3,
        tileLoadFunction: (imageTile, src) => {
            imageTile.getImage().src = src;
        }
    });
    return source;
}