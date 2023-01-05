import 'package:process_run/shell.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const Home());
  //runAndDisplayCommand('tracert 8.8.8.8');
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TraceScreen(),
    );
  }
}

class TraceScreen extends StatefulWidget {

  @override
  State<TraceScreen> createState() => _TraceScreenState();
}

class _TraceScreenState extends State<TraceScreen> {
  late final TextEditingController hostController;
  late final TextEditingController ttlController;
  List<String?>? output;
  String? textOutput = '';
  List<String>? splittedTextOutput=[];

  @override
  void initState() {
    super.initState();

    hostController = TextEditingController();
    ttlController = TextEditingController();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP Tracker'),
        actions:const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text('Powered By : Ahmed Sami ')),
          ),
          Padding(
            padding: EdgeInsets.all(3.0),
            child: CircleAvatar(
              radius: 30,
              
              //child:Image.asset('assets/avatar.jpg'),
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/avatar.jpg',),
              foregroundColor: Colors.transparent,
              ),
          )
        ],
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Input IP address'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'IP address',
                labelText: 'IP',
              ),
              controller: hostController,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    if (textOutput=='') {
                      showLoading(context, output);
                      output = await runAndDisplayCommand(hostController.text,);
                      textOutput = output![4];
                      splittedTextOutput = textOutput?.split(RegExp(r'\s+'));
                      print(splittedTextOutput?[8]);
                      textOutput=splittedTextOutput?[8];
                      Navigator.pop(context);
                    }
                      
                    setState(() {});
                  },
                  child: const Text('Trace'),
                ),
                OutlinedButton(
                  onPressed: () {
                    textOutput='';
                    output=null;
                    hostController.text='';
                    setState((){});
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Container(
                width: MediaQuery.of(context).size.width*0.70,
                height: 100,
                color: textOutput==''? Colors.transparent: Colors.amberAccent,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                               textOutput==''?'': 'This IP is located in :  $textOutput',
                              style: const TextStyle(
                                fontSize: 25,
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textOutput != '' ? Image.asset('assets/ip.png',height: 70,width: 70,) : const SizedBox()
                          ],
                        ),
                      ),
                    )
            ])
          ],
        ),
      ),
    );
  }
}

Future<List<String?>> runAndDisplayCommand(String ip) async {
  List<String>? output;
  var shell = Shell();
  await shell.run('tracert $ip').then((value) {
    output = value.map((e) => e.stdout.toString()).toList();
  });
  List<String?> splittedOutput = output![0].split('\n');
  //print('${splittedOutput[1]}------');
  return splittedOutput;
}

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
