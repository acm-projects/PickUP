import 'package:flutter/material.dart';
import 'package:pickup/classes/game.dart';
import 'package:pickup/classes/user.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  final String gameId;

  const ChatPage(this.gameId, {super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> _messages = [];
  final TextEditingController _controller = TextEditingController();
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 1000), (_) async {
      Map<String, dynamic> gameInfo =
          await Game.fetch(widget.gameId) as Map<String, dynamic>;
      _messages = gameInfo["chat"];
      setState(() {});
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      Game.message(widget.gameId, _controller.text);
      setState(() {
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1A3E2F),
       appBar: PreferredSize(
          preferredSize: const Size.fromHeight(20),  // Reduced height of the AppBar
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF80F37F), Color(0xFF80E046)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                Positioned(
                  top: 15,  // Adjust the top value to move it upwards as needed
                  left: 5,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.only(left: 48),  // Adjust based on IconButton's size
                    alignment: Alignment.center,
                    child: Text(
                      'Game Chat',
                     style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,  // Adjust the top value to move the button upwards as needed
                  left: 4,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMessageListView(),
            ),
            _buildMessageInputRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageListView() {
    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageRow(context, index);
      },
    );
  }

  String wrapTextByCharacterLimit(String inputText, int characterLimit) {
    if (inputText.isEmpty) {
      return ''; // Return an empty string for null or empty input
    }

    final List<String> words = inputText.split(' ');
    final StringBuffer result = StringBuffer();
    String currentLine = '';

    for (final String word in words) {
      if ((currentLine + word).length <= characterLimit) {
        // Add the word to the current line
        currentLine += '$word ';
      } else {
        // Start a new line with the word
        result.writeln(currentLine.trim());
        currentLine = '$word ';
      }
    }

    // Add any remaining content to the result
    result.write(currentLine.trim());

    return result.toString();
  }

  Widget _buildMessageRow(BuildContext context, int index) {
    User.getUserID();
    bool isSender = _messages[index]["user"] == User.userID;

    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSender) // Tail for the receiver on the left
          Transform.rotate(
            angle: 3.14159, // π radians to flip the tail
            child: CustomPaint(
              painter: BubbleTailPainter(isSender: false, color: Colors.white),
              size: const Size(10, 20),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: isSender ? Colors.lightGreen[400] : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            wrapTextByCharacterLimit(_messages[index]["message"], 30),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (isSender) // Tail for the sender on the right
          CustomPaint(
            painter: BubbleTailPainter(
              isSender: true,
              color: Colors.lightGreen[400] ??
                  Colors
                      .lightGreen, // Fallback to default light green if 400 shade is null
            ),
            size: const Size(10, 20),
          ),
      ],
    );
  }

  Widget _buildMessageInputRow() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Type a message",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.green),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class BubbleTailPainter extends CustomPainter {
  final bool isSender;
  final Color color;

  BubbleTailPainter({required this.isSender, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color;
    var path = Path();
    if (isSender) {
      path.moveTo(size.width, size.height * 0.5);
      path.lineTo(size.width - 10, size.height * 0.3);
      path.lineTo(size.width - 10, size.height * 0.7);
    } else {
      path.moveTo(0, size.height * 0.5);
      path.lineTo(10, size.height * 0.3);
      path.lineTo(10, size.height * 0.7);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
