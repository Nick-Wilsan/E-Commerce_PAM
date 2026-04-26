import 'package:flutter/material.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calls',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTopAction(Icons.call, 'Call'),
                _buildTopAction(Icons.calendar_month, 'Schedule'),
                _buildTopAction(Icons.dialpad, 'Keypad'),
                _buildTopAction(Icons.favorite_border, 'Favorites'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Recent',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          _buildCallTile(
            'Teman Kelompok',
            '27 minutes ago',
            true,
            true,
            Colors.red,
          ),
          _buildCallTile(
            'Keluarga',
            'Today, 07:04',
            false,
            false,
            const Color(0xFF00A884),
          ),
          _buildCallTile(
            'Rekan Kerja',
            'Yesterday, 15:34',
            true,
            true,
            Colors.red,
          ),
          _buildCallTile(
            'Sahabat',
            'Yesterday, 14:02',
            false,
            true,
            const Color(0xFF00A884),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00A884),
        onPressed: () {},
        child: const Icon(Icons.add_call, color: Colors.black),
      ),
    );
  }

  Widget _buildTopAction(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF202C33),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCallTile(
    String name,
    String time,
    bool isMissed,
    bool isVideo,
    Color callTypeColor,
  ) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey[800],
        child: const Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        name,
        style: TextStyle(
          color: isMissed ? Colors.red : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            isMissed ? Icons.call_missed : Icons.call_made,
            size: 16,
            color: callTypeColor,
          ),
          const SizedBox(width: 4),
          Text(time, style: const TextStyle(color: Colors.grey)),
        ],
      ),
      trailing: Icon(
        isVideo ? Icons.videocam : Icons.call,
        color: Colors.white,
      ),
    );
  }
}
