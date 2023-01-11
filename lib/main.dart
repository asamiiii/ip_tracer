import 'dart:io';
import 'package:flutter/material.dart';
import 'functions.dart';

void main(List<String> args) {
  runApp(const Home());
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
  List<String>? splittedTextOutput = [];

  @override
  void initState() {
    super.initState();

    hostController = TextEditingController();
    ttlController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: const Text('IP Tracker'),
        actions: const [
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
              backgroundImage: AssetImage(
                'assets/avatar.jpg',
              ),
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.20),
              child: const Text(
                'Input IP address',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.15),
              child: TextField(
                style:TextStyle(fontSize: 50),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.account_tree_outlined),
                    border: OutlineInputBorder(),
                    hintText: 'IP address',
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: 'IP',
                    labelStyle: TextStyle(color: Colors.white)),
                controller: hostController,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.green)),
                  onPressed: () async {
                    if (textOutput == '') {
                      showLoading(context, output);
                      output = await runCommand(
                        hostController.text,
                      );
                      textOutput = output![4];
                      splittedTextOutput = textOutput?.split(RegExp(r'\s+'));
                      //print(splittedTextOutput?[8]);
                      textOutput = splittedTextOutput?[8];
                      // ignore: use_build_context_synchronously
                      hideLoading(context);
                    }

                    setState(() {});
                  },
                  child: const Text('Trace',
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(
                  width: 20,
                ),
                OutlinedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.black)),
                  onPressed: () {
                    textOutput = '';
                    output = null;
                    hostController.text = '';
                    killCommand();
                    setState(() {});
                  },
                  child: const Text('Clear',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.70,
                height: 100,
                color:
                    textOutput == '' ? Colors.transparent : Colors.amberAccent,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        textOutput == ''
                            ? ''
                            : 'This IP is located in :  $textOutput',
                        style: const TextStyle(
                          fontSize: 25,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textOutput != ''
                          ? Image.asset(
                              'assets/ip.png',
                              height: 70,
                              width: 70,
                            )
                          : const SizedBox()
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
