import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

var shell = Shell();

//? run a command line
Future<List<String?>> runCommand(String ip) async {
  List<String>? output;
  await shell.run('tracert $ip').then((value) {
    output = value.map((e) => e.stdout.toString()).toList();
  });
  List<String?> splittedOutput = output![0].split('\n');
  //print('${splittedOutput[1]}------');
  return splittedOutput;
}


//! kill Command
void killCommand(){
  shell.kill();
}


//? Show Loading Indiactor
void showLoading(BuildContext context, List<String?>? output,
    {bool isCancellable = true}) {
      if(output==null){
showDialog(
    context: context,
    barrierDismissible: isCancellable,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: const[
            Text('Loading .. '),
            SizedBox(
              width: 15,
            ),
            CircularProgressIndicator()
          ],
        ),
      );
    },
  );
      }
  
}

hideLoading(BuildContext context){
  Navigator.pop(context);
}