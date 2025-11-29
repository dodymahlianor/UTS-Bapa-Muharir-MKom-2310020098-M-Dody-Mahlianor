import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/item_card.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with SingleTickerProviderStateMixin {
  // Data Dummy
  final List<Map<String, String>> _places = [
    {
      'id': '1',
      'title': 'Pulau Kembang',
      'subtitle': 'Habitat Kera Ekor Panjang & Bekantan',
      'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80',
      'link': 'https://id.wikipedia.org/wiki/Pulau_Kembang'
    },
    {
      'id': '2',
      'title': 'Pegunungan Meratus',
      'subtitle': 'Geopark Nasional & Budaya Dayak',
      'image': 'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=800&q=80',
      'link': 'https://id.wikipedia.org/wiki/Pegunungan_Meratus'
    },
    {
      'id': '3',
      'title': 'Pasar Terapung Lok Baintan',
      'subtitle': 'Warisan Budaya Sungai Martapura',
      'image': 'https://images.unsplash.com/photo-1596423126780-6060c41031c0?auto=format&fit=crop&w=800&q=80',
      'link': 'https://id.wikipedia.org/wiki/Pasar_Terapung_Lok_Baintan'
    },
    {
      'id': '4',
      'title': 'Tahura Sultan Adam',
      'subtitle': 'Bukit, Waduk & Pemandangan Alam',
      'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=800&q=80',
      'link': 'https://id.wikipedia.org/wiki/Taman_Hutan_Raya_Sultan_Adam'
    },
    {
      'id': '5',
      'title': 'Danau Biru Pengaron',
      'subtitle': 'Eksotisme Bekas Tambang',
      'image': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=800&q=80',
      'link': 'https://banjarmasin.tribunnews.com/'
    },
  ];

  final Map<String, List<String>> _comments = {};
  late final AnimationController _controller;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    for (var p in _places) {
      _comments[p['id']!] = [];
    }

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    
    // Staggered animation setup
    _animations = List.generate(_places.length, (index) {
      final start = index * 0.1;
      final end = (start + 0.5).clamp(0.0, 1.0);
      return CurvedAnimation(
          parent: _controller, curve: Interval(start, end, curve: Curves.easeOut));
    });

    Timer(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openComments(String id, String title) {
    final TextEditingController c = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: SizedBox(
            height: 400,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Komentar: $title", style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close))
                  ],
                ),
                const Divider(),
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setModalState) {
                      return _comments[id]!.isEmpty
                          ? const Center(child: Text('Belum ada komentar. Jadilah yang pertama!'))
                          : ListView.builder(
                              itemCount: _comments[id]!.length,
                              itemBuilder: (context, idx) {
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.teal[100],
                                    child: const Icon(Icons.person, color: Colors.teal),
                                  ),
                                  title: Text(_comments[id]![idx]),
                                  subtitle: const Text('Pengunjung', style: TextStyle(fontSize: 12)),
                                );
                              },
                            );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: c,
                          decoration: InputDecoration(
                            hintText: 'Tulis komentar...',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white, size: 20),
                          onPressed: () {
                            if (c.text.trim().isEmpty) return;
                            setState(() {
                              _comments[id]!.insert(0, c.text.trim());
                            });
                            Navigator.pop(ctx); // Close and reopen or use StatefulBuilder to update
                            _openComments(id, title); // Hacky reload for simple example
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLink(String url) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Info Link'),
        content: Text(url),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link berhasil disalin!')));
            },
            child: const Text('Salin Link'),
          ),
        ],
      ),
    );
  }

  void _onLike() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Anda menyukai tempat ini ❤️'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openDetail(Map<String, String> p) {
    Navigator.pushNamed(context, '/detail', arguments: p);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinasi Wisata'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // Logout sederhana
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _places.length,
        itemBuilder: (context, index) {
          final p = _places[index];
          return ItemCard(
            id: p['id']!,
            title: p['title']!,
            subtitle: p['subtitle']!,
            imageUrl: p['image']!,
            commentsCount: _comments[p['id']!]!.length,
            animation: _animations[index],
            onTap: () => _openDetail(p),
            onLike: _onLike,
            onComment: () => _openComments(p['id']!, p['title']!),
            onLink: () => _showLink(p['link']!),
          );
        },
      ),
    );
  }
}