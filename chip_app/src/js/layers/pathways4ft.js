"use strict";

import TileLayer from "ol/layer/Tile";
import XYZ from "ol/source/XYZ";

import MVT from 'ol/format/MVT';
import VectorTileLayer from 'ol/layer/VectorTile';
import VectorTileSource from 'ol/source/VectorTile';

export function layer(map) {
    let source = _source();

    let layer = new VectorTileLayer({
        visible: false,
        preload: 4,
        opacity: 1,
        source: source
    });
    layer.set("name", "stormtide_pathways_4ft");

    map.on("render_stp4ft", ({data}) => {
        layer.setVisible(true);
    });

    map.on("disable_stp4ft", () => {
        layer.setVisible(false);
    });

    return layer;
}

function _source() {
    let source = new VectorTileSource({
        format: new MVT(),
        url: process.env.ELM_APP_AGS_PATHWAYS_FOUR,
        maxZoom: 16,
        minZoom: 3,
        opaque: false,
        transition: 4
        
    });
    return source;
}
