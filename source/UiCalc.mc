using Toybox.Math;

class UiCalc {

  // Calculate the coordinates for small numbers (hours) on the edge of the dial
  function calculateSmallDialNums(halfWidth) {
    var angleDeg = 0;
    var pointX = 0;
    var pointY = 0;
    var hoursCircle = halfWidth - 15;
    var angleToNrCorrection = -6;
    var numCoords = {};
    var hourValue = null;

    for(var nr = 1; nr < 24; nr+=1) {
        if ((nr != 6) && (nr != 12) && (nr != 18)) {
          angleDeg = ((nr * 15) * Math.PI) / 180;
          pointX = ((hoursCircle * Math.cos(angleDeg)) + halfWidth);
          pointY = ((hoursCircle * Math.sin(angleDeg)) + halfWidth);

          hourValue = nr + angleToNrCorrection;
          switch (hourValue) {
            case 1:
            numCoords.put(hourValue, [pointX.toNumber(), pointY.toNumber() - 15]);
            break;

            case 2:
            numCoords.put(hourValue, [pointX.toNumber() + 1, pointY.toNumber() - 14]);
            break;

            case 3:
            numCoords.put(hourValue, [pointX.toNumber() + 3, pointY.toNumber() - 15]);
            break;

            case 4:
            numCoords.put(hourValue, [pointX.toNumber() + 5, pointY.toNumber() - 13]);
            break;

            case 5:
            numCoords.put(hourValue, [pointX.toNumber() + 4, pointY.toNumber() - 14]);
            break;

            case 7:
            numCoords.put(hourValue, [pointX.toNumber() + 4, pointY.toNumber() - 12]);
            break;

            case 8:
            numCoords.put(hourValue, [pointX.toNumber() + 4, pointY.toNumber() - 10]);
            break;

            case 9:
            numCoords.put(hourValue, [pointX.toNumber() + 4, pointY.toNumber() - 8]);
            break;

            case 10:
            numCoords.put(hourValue, [pointX.toNumber(), pointY.toNumber() - 7, pointX.toNumber() + 6, pointY.toNumber() - 10]);
            break;

            case 11:
            numCoords.put(hourValue, [pointX.toNumber() - 2, pointY.toNumber() - 6, pointX.toNumber() + 6, pointY.toNumber() - 8]);
            break;

            case 13:
            numCoords.put(hourValue, [pointX.toNumber() - 5, pointY.toNumber() - 8, pointX.toNumber() + 3, pointY.toNumber() - 5]);
            break;

            case 14:
            numCoords.put(hourValue, [pointX.toNumber() - 6, pointY.toNumber() - 10, pointX.toNumber() + 2, pointY.toNumber() - 4]);
            break;

            case 15:
            numCoords.put(hourValue, [pointX.toNumber() - 6, pointY.toNumber() - 11, pointX.toNumber(), pointY.toNumber() - 5]);
            break;

            case 16:
            numCoords.put(hourValue, [pointX.toNumber() - 5, pointY.toNumber() - 13, pointX.toNumber() - 1, pointY.toNumber() - 5]);
            break;

            case 17:
            numCoords.put(hourValue, [pointX.toNumber() - 5, pointY.toNumber() - 15, pointX.toNumber() - 3, pointY.toNumber() - 6]);
            break;

            case -1:	// 23
            numCoords.put(hourValue, [pointX.toNumber() - 6, pointY.toNumber() - 15, pointX.toNumber() + 3, pointY.toNumber() - 17]);
            break;

            case -2:	// 22
            numCoords.put(hourValue, [pointX.toNumber() - 5, pointY.toNumber() - 12, pointX.toNumber() + 4, pointY.toNumber() - 17]);
            break;

            case -3:	// 21
            numCoords.put(hourValue, [pointX.toNumber() - 5, pointY.toNumber() - 10, pointX.toNumber() + 1, pointY.toNumber() - 18]);
            break;

            case -4:	// 20
            numCoords.put(hourValue, [pointX.toNumber() - 5, pointY.toNumber() - 10, pointX.toNumber(), pointY.toNumber() - 19]);
            break;

            case -5:	// 19
            numCoords.put(hourValue, [pointX.toNumber() - 5, pointY.toNumber() - 10, pointX.toNumber() - 3, pointY.toNumber() - 18]);
            break;
          }
        }
      }

    return numCoords;
  }

  // Calculate the coordinates for indicators numbers (hours) on the edge of the dial
  function calculateSmallDialLines(halfWidth) {
    var linesCoords = {};
    var angleDeg = 0;
    var pointX =  0;
    var pointY = 0;
    for(var angle = 0; angle < 360; angle+=15) {
      if ((angle != 0) && (angle != 90) && (angle != 180) && (angle != 270)) {
        angleDeg = (angle * Math.PI) / 180;
        pointX = ((halfWidth * Math.cos(angleDeg)) + halfWidth);
        pointY = ((halfWidth * Math.sin(angleDeg)) + halfWidth);
        linesCoords.put(angle, [pointX, pointY]);
      }
    }

    return linesCoords;
  }

}
