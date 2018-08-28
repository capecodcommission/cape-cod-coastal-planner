"use strict";

import {fromLonLat} from "ol/proj";

const requestAnimationFrame = 
    window.requestAnimationFrame ||
    window.mozRequestAnimationFrame ||
    window.webkitRequestAnimationFrame ||
    window.msRequestAnimationFrame;

export function getRAF() {
    return requestAnimationFrame;
}

export function logError(err) {
    if (shouldUseRollbar()) {
        Rollbar.error(err);
    } else {
        console.log(err);
    }
}

function shouldUseRollbar() {
    let isRollbarAvailable = window._rollbarConfig && window._rollbarConfig.enabled && Rollbar;
    let isEnvironmentAppropriate = process.env.NODE_ENV !== "development";
    return isRollbarAvailable && isEnvironmentAppropriate;
}

export function convertExtent([minX, minY, maxX, maxY]) {
    let convertedExtent = [
        fromLonLat([minX, 0])[0],
        fromLonLat([0, minY])[1],
        fromLonLat([maxX, 0])[0],
        fromLonLat([0, maxY])[1]
    ];
    return convertedExtent;
}

export function compareFeaturesById(feature1, feature2) {
    let id1 = Number.isInteger(feature1.get('id')) || feature1.ol_uid || 0;
    let id2 = Number.isInteger(feature2.get('id')) || feature2.ol_uid || 1;

    if (id1 < id2) {
        return -1;
    }
    if (id1 > id2) {
        return 1;
    }
    return 0;
};