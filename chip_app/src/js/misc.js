"use strict";


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