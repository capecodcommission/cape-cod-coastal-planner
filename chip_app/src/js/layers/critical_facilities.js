"use strict";

import VectorLayer  from "ol/layer/Vector";
import VectorSource  from "ol/source/Vector";
import EsriJSON from "ol/format/EsriJSON";

export function layer() {
    let source = _source();

    let layer = new VectorLayer ({
        visible: true,
        source: source
    });
    layer.set("name", "critical_facilities");
    return layer;
}

function _source() {
    let url = process.env.ELM_APP_AGS_CRIT_URL;
    if (!url) {
        throw Error("Must configure environment variable `ELM_APP_AGS_MASS_IMG_URL`!");
    }
    let source = new VectorSource({
        url: url,
        format: new EsriJSON()
    });
    return source;
}
