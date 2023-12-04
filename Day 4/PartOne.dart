import 'dart:io';

void main(){
  List<String> input = File("./input.txt").readAsLinesSync();
  
  int output = 0;

  for (var i = 0; i < input.length; i++){
    var sides = input[i].split(":")[1].split("|").map((e) => e.split(RegExp(r'\s+'))).toList();
    int out = 0;

    for (var j = 0; j < sides[0].length; j++){
      if(sides[0][j] == ""){
        continue;
      }
      if(sides[1].contains(sides[0][j])){
        if(out == 0){
          out = 1;
        }else{
          out *= 2;
        }
      }
    }
    output += out;
  }
  print("Output: " + output.toString());

}