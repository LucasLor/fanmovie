int getActualYear(){
  return DateTime.now().year;
}

String formatDuration(Duration d) => '${d.inHours}h ${d.inMinutes.remainder(60).toString().padLeft(2, '0')}m';