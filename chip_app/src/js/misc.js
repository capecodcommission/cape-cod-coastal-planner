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


const ribbonColors = {
    roofTerracotta: "#A41B1E",
    burntSienna: "#F3755C",
    maize: "#F5C8AB"
};

export function getVulnRibbonSegmentColor(feature) {
    if (!feature || !(typeof feature.get === 'function')) return "#3399CC";
    
    let ribbonScore = feature.get("RibbonScore");
    if (ribbonScore >= 6) {
        return ribbonColors.roofTerracotta;
    } else if (ribbonScore <= 0) {
        return ribbonColors.maize;
    } else {
        return ribbonColors.burntSienna;
    }
};

const coastalColors = {
    groins: "#7570b3",
    revetment: "#1b9e77",
    jetty: "#d95f02"
};


export function getCoastalColors(feature) {
    if (!feature || !(typeof feature.get === 'function')) return "#3399CC";
    
    let structureType = feature.get("CoastalStructureType");
    
    switch (structureType) {
        
        case "Groins":
            return coastalColors.groins
        
        case "Revetment":
            return coastalColors.revetment
        
        case "Jetty":
            return coastalColors.jetty
    }
};

const pprColors = {
    private: "#9c9c9c",
    public: "#000000"
}

export function getPPRColors(feature) {
    if (!feature || !(typeof feature.get === 'function')) return "#3399CC";
    
    let ownerType = feature.get("Ownership");
    
    switch (ownerType) {
        
        case "Private":
            return pprColors.private
        
        case "Public":
            return pprColors.public
    }
};

const fyeColors = {
    Erosion: " #FF7F7F",
    Accretion: "#D1FF73"
}

export function getFYEColors(feature) {
    if (!feature || !(typeof feature.get === 'function')) return "#3399CC";
    
    let erosion = feature.get("Erosion_M");
    let accretion = feature.get("Accretion_M");
    
    if (erosion) {
        return fyeColors.Erosion
    }

    if (accretion) {
        return fyeColors.Accretion
    }
};

export function getSTIRotation(feature) {
    if (!feature || !(typeof feature.get === 'function')) return 0;
    
    let vector = feature.get("Vector");
    
    return vector
};