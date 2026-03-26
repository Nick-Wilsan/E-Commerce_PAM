import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "Nick Wilsan";
  bool isEditing = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = userName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ACCOUNT',
          style: TextStyle(color: Color(0xFFD4AF37)),
        ), // Gold
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (isEditing) userName = _nameController.text;
                isEditing = !isEditing;
              });
            },
            child: Text(
              isEditing ? 'SAVE' : 'EDIT',
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Header Profil
              const Text(
                'PERSONAL DETAILS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              isEditing
                  ? TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF1A1A24)),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  : Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
              const SizedBox(height: 8),
              const Text(
                'nick.wilsan@example.com',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 48),

              // Bagian Menu Navigasi
              _buildMenuTile(
                icon: Icons.shopping_bag_outlined,
                title: 'Order History',
                subtitle: 'Lacak pesanan dan lihat riwayat pembelian',
              ),
              _buildMenuTile(
                icon: Icons.favorite_border,
                title: 'Saved Items',
                subtitle: 'Lihat produk yang kamu simpan',
              ),
              _buildMenuTile(
                icon: Icons.location_on_outlined,
                title: 'Shipping Addresses',
                subtitle: 'Kost - Malang, Jawa Timur',
              ),
              _buildMenuTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'Kata sandi, notifikasi, dan preferensi',
              ),

              const SizedBox(height: 48),

              // Tombol Logout
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'SIGN OUT',
                    style: TextStyle(
                      color: Colors.redAccent,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: () {
          // Navigasi ke sub-menu
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF1A1A24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
