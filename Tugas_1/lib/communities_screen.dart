import 'package:flutter/material.dart';

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Communities',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.groups, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF00A884),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.black, size: 16),
                  ),
                ),
              ],
            ),
            title: const Text(
              'New community',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(color: Colors.black, thickness: 8),
          _buildCommunityGroup(
            'Fakultas Teknologi',
            'Announcements',
            '12/11/25',
          ),
          const Divider(color: Colors.black, thickness: 8),
          _buildCommunityGroup('Angkatan 2024', 'Announcements', '1/20/26'),
        ],
      ),
    );
  }

  Widget _buildCommunityGroup(String groupName, String subGroup, String date) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.domain, color: Colors.white),
          ),
          title: Text(
            groupName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.campaign, color: Color(0xFF00A884)),
          title: Text(subGroup),
          subtitle: const Text('Admin: Info penting terkait jadwal...'),
          trailing: Text(
            date,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 70.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('View all >', style: TextStyle(color: Colors.grey)),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
