import 'package:flutter/material.dart';

class ChatRoomScreen extends StatelessWidget {
  final String chatName;

  const ChatRoomScreen({super.key, required this.chatName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_back),
              const SizedBox(width: 4),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[700],
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
        title: Text(chatName, style: const TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.call_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://i.pinimg.com/originals/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg',
            ), // Contoh background WA gelap
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const ChatBubble(
                    message: 'Halo, apakah unit mobil ini masih tersedia?',
                    isMe: false,
                    time: '15:12',
                  ),
                  ProductChatBubble(
                    productName: 'Honda HR-V 1.5 SE CVT 2023 - Aka Mobilindo',
                    productPrice: 'Rp 345.000.000',
                    productDesc:
                        'Pajak hidup, KM rendah, full original luar dalam. Tersedia opsi kredit DP ringan.',
                    imageUrl:
                        'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?q=80&w=1000&auto=format&fit=crop', // Contoh gambar dummy
                    isMe: true,
                    time: '15:13',
                    onAddToCart: () {
                      // Aksi ketika tombol ATC ditekan
                      print('Produk dimasukkan ke keranjang');
                    },
                  ),
                  const ChatBubble(
                    message: 'Masih ready ya kak, unit mulus siap pakai.',
                    isMe: true,
                    time: '15:14',
                  ),
                ],
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF202C33),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {},
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF00A884),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF005C4B) : const Color(0xFF202C33),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(message, style: const TextStyle(fontSize: 15)),
            ),
            const SizedBox(width: 8),
            Text(time, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
            if (isMe) ...[
              const SizedBox(width: 4),
              const Icon(Icons.done_all, color: Colors.blue, size: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class ProductChatBubble extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productDesc;
  final String imageUrl;
  final bool isMe;
  final String time;
  final VoidCallback onAddToCart;

  const ProductChatBubble({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productDesc,
    required this.imageUrl,
    required this.isMe,
    required this.time,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(
          maxWidth: 280,
        ), // Sedikit lebih ramping dari bubble teks
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF005C4B) : const Color(0xFF202C33),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Detail Produk
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    productDesc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    productPrice,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.black.withOpacity(0.3)),

            // Tombol Add to Cart (ATC)
            InkWell(
              onTap: onAddToCart,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                child: const Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(
                    color: Color(0xFF00A884),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),

            // Waktu dan Status Centang
            Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.done_all, color: Colors.blue, size: 14),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
