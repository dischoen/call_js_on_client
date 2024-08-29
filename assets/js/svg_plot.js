"use strict";

export function addPoint(x, y, polylineId) {
    var polyline = document.getElementById(polylineId);
    const svg = polyline.ownerSVGElement;
    var point = svg.createSVGPoint();
    point.x = x;
    point.y = y;
    polyline.points.appendItem(point);
}

export function deleteFirstPoint(polylineId) {
    const polyline = document.getElementById(polylineId);
    if (!polyline) {
        return;
    }
    polyline.points.removeItem(0);
}

export function getFirstPointX(polylineId) {

    const polyline = document.getElementById(polylineId);
    if (!polyline) {
        console.log('Polyline not found');
        return -1;
    }
    const points = polyline.getAttribute('points');
    const pointsArray = points.trim().split(/\s+/);
    if (pointsArray.length === 0) {
        console.error('No points found in polyline');
        return -1;
    }
    const firstPoint = pointsArray[0];
    const [x, y] = firstPoint.split(',').map(Number);
    return x; 
}

export function add_point(x, y, polylineId) {
    let max = 123
    let timeframe = 123
    
    if (y > max|| y<0) {
        return;
    } else {
        y = Math.floor((500 * y / max));
    }


    for(i=1;i<=2;i++){
        id = "polyline" + i.toString();
        movePolylineWithX(x, id, timeframe);
    }
    

    while (getFirstPointX(polylineId) < 0) {
        deleteFirstPoint(polylineId)
        if(!getFirstPointX(polylineId)){
            break;
        }
    }
    addPoint(500, y, polylineId);
}

export function movePolylineWithX(x, polylineId, timeframe) {
    const distance = (x / timeframe * 500);
    const polyline = document.getElementById(polylineId);

    if (!polyline) {
        console.log('Polyline not found');
        return;
    }

    for(idx=0; idx<polyline.points.length; idx++) {
        let p = polyline.points.getItem(idx);
        p.x -= distance;
        polyline.points.replaceItem(p, idx);
    }
}
