import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0C2219),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Chat'),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Mada',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF88F37F), Color(0xFF88F37F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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
        final bool isSender = index % 2 == 0;
        return _buildMessageRow(context, index, isSender);
      },
    );
  }

  Widget _buildMessageRow(BuildContext context, int index, bool isSender) {
    return Row(
      mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
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
            _messages[index],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (isSender) // Tail for the sender on the right
          CustomPaint(
  painter: BubbleTailPainter(
    isSender: true,
    color: Colors.lightGreen[400] ?? Colors.lightGreen, // Fallback to default light green if 400 shade is null
  ),
  size: const Size(10, 20),
),

      ],
    );
  }

  Widget _buildMessageInputRow() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
