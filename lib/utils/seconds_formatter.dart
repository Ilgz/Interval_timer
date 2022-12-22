String formatterTime(int timeInSeconds) {
  String formattedString = "";
  int seconds = timeInSeconds;
  int minutes = 0;
  int hours = 0;
  while (true) {
    if ((seconds - 60) >= 0) {
      seconds -= 60;
      minutes++;
    } else {
      break;
    }
  }
  while (true) {
    if ((minutes - 60) >= 0) {
      minutes -= 60;
      hours++;
    } else {
      break;
    }
  }
  formattedString += seconds.toString().length == 1
      ? "0" + seconds.toString()
      : seconds.toString();
  String minutesFormatted = minutes.toString().length == 1
      ? "0" + minutes.toString()
      : minutes.toString();
  String hoursFormatted = "";
  if (hours.toString() != "0") {
    hoursFormatted = (hours.toString().length == 1
        ? "0" + hours.toString()
        : hours.toString()) +
        ":";
  }
  formattedString = hoursFormatted + minutesFormatted + ":" + formattedString;
  return formattedString;
}