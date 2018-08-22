"use strict";

import {
  union,
  difference,
  intersect,
  buffer,
  truncate,
  simplify,
  booleanContains
} from "@turf/turf";
import {
  lineString,
  multiLineString,
  polygon,
  multiPolygon
} from "@turf/helpers";
import { toWgs84, toMercator } from "@turf/projection";
import Point from "ol/geom/point";
import LineString from "ol/geom/linestring";
import MultiLineString from "ol/geom/multilinestring";
import Polygon from "ol/geom/polygon";
import Circle from "ol/geom/circle";
import GeoJSON from "ol/format/geojson";

const POINT = "Point";
const LINE = "LineString";
const POLYGON = "Polygon";
const MULTI_POINT = "MultiPoint";
const MULTI_LINE = "MultiLineString";
const MULTI_POLYGON = "MultiPolygon";
const CIRCLE = "Circle";
const METERS_PER_MILE = 1609.34;

export function containsPolygon(geom1, geom2) {
  if (!geom1 || !geom2) {
    throw new Error("Must provide two valid geometries.");
  }

  try {
    let shape1 = convertPolygon(geom1);

    let shape2 = convertPolygon(geom2);

    let contains = booleanContains(shape1, shape2);
    return contains;
  } catch (err) {
    throw new Error(`Error unioning polygons: ${err}`);
  }
}

/**
 * Convert a Point geometry into a circular polygon with the given radius.
 * @param {Point} point
 * @param {Float} radius
 * @return {Polygon} asPolygon
 */
export function pointToCircle(point, radius) {
  if (!point || !(point instanceof Point) || parseFloat(radius) === NaN) {
    throw new Error("Must provide a valid Point geometry and radius.");
  }

  let circle = new Circle(point.getCoordinates(), radius * METERS_PER_MILE);
  let asPolygon = Polygon.fromCircle(circle);
  return asPolygon;
}

/**
 * Convert a LineString or MultiLinString to a polygon buffered by given radius.
 * @param {LineString|MultiLineString} line
 * @param {Float} radius
 * @return {Polygon} simplified
 */
export function lineToPolygon(line, radius) {
  if (
    !line ||
    (!(line instanceof LineString) && !(line instanceof MultiLineString)) ||
    parseFloat(radius) === NaN
  ) {
    throw new Error(
      "Must provide a valid LineString or MultiLineString geometry and radius."
    );
  }
  try {
    let shape = null;
    switch (line.getType()) {
      case LINE:
        shape = lineString(line.getCoordinates());
        break;

      case MULTI_LINE:
        shape = multiLineString(line.getCoordinates());
        break;

      default:
        throw new Error(
          `Invalid Geometry type: ${geometry.getType()}. Geometry must be either a ${LINE} or ${MULTI_LINE}.`
        );
        break;
    }
    shape = toWgs84(shape);
    shape = truncate(shape);

    let buffered = buffer(shape, radius, { units: "miles" });
    buffered = simplifyIfGreaterThan(500, buffered);
    buffered = toMercator(buffered);

    let format = new GeoJSON();
    let formatted = format.readGeometryFromObject(buffered.geometry);
    return formatted;
  } catch (err) {
    throw new Error(`Error buffering linestring: ${err}`);
  }
}

/**
 * Buffers the given polygon or multipolygon by the given buffer amount
 * and then simplifies the result to keep vertice count reasonable. If the
 * amount is 0, simply return the original geometry.
 * @param {Polygon|MultiPolygon} geometry
 * @param {Float} radius
 * @return {Polygon|MultiPolygon} simplified
 */
export function bufferPolygon(geometry, radius) {
  if (!geometry || parseFloat(radius) === NaN) {
    throw new Error("Must provide a valid geometry and radius.");
  }

  if (radius == 0) {
    return geometry;
  }

  try {
    let shape = convertPolygon(geometry);
    shape = toWgs84(shape);
    shape = truncate(shape);

    let buffered = buffer(shape, radius, { units: "miles" });
    buffered = simplifyIfGreaterThan(500, buffered);
    buffered = toMercator(buffered);

    let format = new GeoJSON();
    let formatted = format.readGeometryFromObject(buffered.geometry);
    return formatted;
  } catch (err) {
    throw new Error(`Error buffering polygon: ${err}`);
  }
}

/**
 * Union two polygons or multipolygons.
 * @param {Polygon|MultiPolygon} geom1
 * @param {Polygon|MultiPolygon} geom2
 * @return {Polygon|MultiPolygon} formatted
 */
export function unionPolygons(geom1, geom2) {
  if (!geom1 || !geom2) {
    throw new Error("Must provide two valid geometries.");
  }

  try {
    let shape1 = convertPolygon(geom1);

    let shape2 = convertPolygon(geom2);

    let unioned = union(shape1, shape2);

    let format = new GeoJSON();
    let formatted = format.readGeometryFromObject(unioned.geometry);
    return formatted;
  } catch (err) {
    throw new Error(`Error unioning polygons: ${err}`);
  }
}

/**
 * Cut one polygon from another polygon.
 * @param {Polygon|MultiPolygon} cuttee
 * @param {Polygon|MultiPolygon} cutter
 * @return {Polygon|MultiPolygon|null} formatted or null if no shape remains
 */
export function cutPolygons(cuttee, cutter) {
  if (!cuttee || !cutter) {
    throw new Error("Must provide two valid geometries.");
  }

  try {
    let cutterShape = convertPolygon(cutter);

    let cutteeShape = convertPolygon(cuttee);

    let differenced = difference(cutteeShape, cutterShape);
    if (differenced) {
      let format = new GeoJSON();
      let formatted = format.readGeometryFromObject(differenced.geometry);
      return formatted;
    } else {
      return null;
    }
  } catch (err) {
    throw new Error(`Error differencing polygons: ${err}`);
  }
}

/**
 * Finds intersection b/t shapes
 * @param {Polygon|MultiPolygon} geom1
 * @param {Polygon|MultiPolygon} geom2
 * @return {Polygon|MultiPolygon|null} formatted or null if no intersection found
 */
export function intersectPolygons(geom1, geom2) {
  if (!geom1 || !geom2) {
    throw new Error("Must provide two valid goemetries.");
  }

  try {
    let shape1 = convertPolygon(geom1);
    shape1 = toWgs84(shape1);

    let shape2 = convertPolygon(geom2);
    shape2 = toWgs84(shape2);

    let intersection;
    switch (shape1.geometry.type) {
      case POLYGON:
        intersection = intersect(shape1, shape2);
        break;

      case MULTI_POLYGON:
        intersection = shape1.geometry.coordinates.reduce((acc, nextCoords) => {
          let nextPolygon = nextCoords;
          if (nextCoords instanceof Array) {
            nextPolygon = polygon(nextCoords);
          }

          let intr = intersect(nextPolygon, shape2);
          if (intr && acc) {
            switch (intr.geometry.type) {
              case POLYGON:
              case MULTI_POLYGON:
                return union(acc, intr);
              default:
                return union(acc, nextPolygon);
            }
          } else if (intr) {
            switch (intr.geometry.type) {
              case POLYGON:
              case MULTI_POLYGON:
                return intr;
              default:
                return nextPolygon;
            }
          } else {
            return acc;
          }
        }, null);
        break;

      default:
        throw new Error("Geometry must be a polygon or a multipolygon.");
    }
    if (intersection) {
      switch (intersection.geometry.type) {
        case POLYGON:
        case MULTI_POLYGON:
          intersection = toMercator(intersection);
          let format = new GeoJSON();
          let formatted = format.readGeometryFromObject(intersection.geometry);
          return formatted;

        default:
          return geom1;
      }
    } else {
      return null;
    }
  } catch (err) {
    throw new Error(`Error intersecting polygons: ${err}`);
  }
}

function convertPolygon(geom) {
  let shape = null;

  if (!geom.getType) return geom;

  switch (geom.getType()) {
    case POLYGON:
      shape = polygon(geom.getCoordinates());
      break;

    case MULTI_POLYGON:
      shape = multiPolygon(geom.getCoordinates());
      break;

    default:
      throw new Error(
        `Invalid Geometry type: ${geometry.getType()}. Geometry must be either a Polygon or MultiPolygon.`
      );
  }
  return shape;
}

/**
 * Simplify a geometry if its vertice count exceeds the provided limit.
 * @param {int} limit
 * @param {GeoJSON} geojson - Polygon or MultiPolygon
 * @return {GeoJSON}
 */
function simplifyIfGreaterThan(limit, geojson) {
  if (!limit) {
    limit = 1000;
  }

  let verticeCount;
  switch (geojson.geometry.type) {
    case POLYGON:
      verticeCount = geojson.geometry.coordinates[0].length;
      break;

    case MULTI_POLYGON:
      verticeCount = geojson.geometry.coordinates[0][0].length;
      break;

    default:
      verticeCount = 0;
      break;
  }

  if (verticeCount >= limit) {
    geojson = simplify(geojson, { tolerance: 0.001, mutate: true });
  }
  return geojson;
}
