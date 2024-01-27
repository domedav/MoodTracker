class Mood{
  int value = 0;
  DateTime time = DateTime.fromMillisecondsSinceEpoch(0);
  String comment = '';

  Mood(this.value, this.time, this.comment);

  @override
  String toString(){
    return '$value\n${time.millisecondsSinceEpoch}\n$comment';
  }

  Mood parseString(String data){
    final vals = data.split('\n');

    value = int.parse(vals[0].trim());
    time = DateTime.fromMillisecondsSinceEpoch(int.parse(vals[1].trim()));
    comment = vals[2].trim();

    return this;
  }
}