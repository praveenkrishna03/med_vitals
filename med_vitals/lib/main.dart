import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black, // Change status bar color to black
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF29AB87),
    ));

    return MaterialApp(
      title: 'Med Vitals',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF29AB87),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // Set app bar color to white
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Color(0xFF004B49),
            fontFamily: 'Rubik',
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
          bodyText2: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: 'Rubik',
          ),
          button: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home, color: Color(0xFF004B49)),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
        title: Center(
          child: Text(
            'Med Vitals',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Color(0xFF004B49)),
            onPressed: () {
              // Handle options
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '         Welcome to Med Vitals',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '             Where Healing begins!',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: 16.0),
                Text(
                  'We understand the power of your voice in fostering mental well-being. Our innovative platform invites you to start your journey towards a sound mind by simply expressing your thoughts. As your virtual mental health companion, we listen attentively, analyze your needs, and prescribe medication tailored to your unique requirements.',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 32.0),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecordingPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 2),
                          backgroundColor: Color(0xFFFFFFFF),
                        ),
                        child: Text(
                          'Start Recording',
                          style: Theme.of(context).textTheme.button?.copyWith(
                                color: Color(0xFF29AB87),
                              ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          try {
                            openFileExplorer();
                          } catch (e) {
                            print('Error opening file explorer: $e');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 2),
                          backgroundColor: Color(0xFFFFFFFF),
                        ),
                        child: Text(
                          'Upload Audio from Device',
                          style: Theme.of(context).textTheme.button?.copyWith(
                                color: Color(0xFF29AB87),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      print('File path: ${file.path}');
      print('File name: ${file.name}');
      print('File size: ${file.size}');
    } else {
      print('User canceled file picking');
    }
  }
}

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  bool isRecording = false;
  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.black),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
        title: Center(
          child: Text(
            'Med Vitals',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle options
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.0),
                Center(
                  child: Column(
                    children: [
                      if (isRecording)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isPaused = !isPaused;
                                });
                              },
                              icon: Icon(
                                isPaused ? Icons.play_arrow : Icons.pause,
                                size: 40.0,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isRecording = false;
                                  isPaused = false;
                                });
                                _showSubmitDialog(context);
                              },
                              icon: Icon(
                                Icons.stop,
                                size: 40.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      else
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isRecording = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .transparent, // Make the button transparent
                          ),
                          child: Container(
                            width: 50, // Adjust the width as needed
                            height: 80, // Adjust the height as needed
                            child: Icon(
                              Icons.mic,
                              size:
                                  50, // Adjust the size of the mic icon as needed
                              color: Colors
                                  .white, // Set the color of the mic icon to white
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit Audio',
              style:
                  TextStyle(color: Colors.black)), // Change text color to black
          content: Text('Would you like to submit the recorded audio?',
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFF29AB87)), // Jungle green color
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showViewReportDialog(context);
              },
              child: Text('Submit'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFF29AB87)), // Jungle green color
              ),
            ),
          ],
        );
      },
    );
  }

  void _showViewReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Audio Submitted'),
          content: SizedBox(
            width: 500, // Adjust the width as needed
            height: 150,
            child: Column(
              children: [
                Text('Would you like to view the report?\n',
                    style: TextStyle(color: Colors.black)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFFFFF),
                  ),
                  child: Text(
                    'View Report',
                    style: Theme.of(context).textTheme.button?.copyWith(
                          color: Color(0xFF29AB87),
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.black),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
        title: Center(
          child: Text(
            'Med Vitals',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle options
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '                   Report',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 30, // Adjust the font size as needed
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                'People with symptoms similar to yours can usually manage their symptoms safely at home. You could also seek advice by visiting or contacting your local pharmacy. If your symptoms persist longer than expected, if they get worse, or if you notice new symptoms, you should consult a doctor for further assessment and advice.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
