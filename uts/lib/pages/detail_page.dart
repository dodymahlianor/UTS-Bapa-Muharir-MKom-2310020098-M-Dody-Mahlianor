import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menangkap argumen yang dikirim dari ListPage
    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    Map<String, String> data = {};
    
    if (rawArgs != null && rawArgs is Map) {
      data = Map<String, String>.from(rawArgs);
    }

    final title = data['title'] ?? 'Detail Wisata';
    final image = data['image'] ?? '';
    final subtitle = data['subtitle'] ?? '';
    final link = data['link'] ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title, 
                style: const TextStyle(
                  color: Colors.white, 
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)]
                )
              ),
              background: image.isNotEmpty
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(color: Colors.grey),
                    )
                  : Container(color: Colors.teal),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.teal),
                        const SizedBox(width: 8),
                        Expanded(child: Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.grey))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Deskripsi",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Tempat ini menawarkan pengalaman wisata yang tak terlupakan di Kalimantan Selatan. Dengan pemandangan alam yang asri, udara segar, dan keramahan penduduk lokal, destinasi ini menjadi pilihan tepat untuk liburan keluarga maupun petualangan solo.",
                      style: TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final uri = Uri.tryParse(link);
                          if (uri != null && await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tidak dapat membuka link')));
                          }
                        },
                        icon: const Icon(Icons.map),
                        label: const Text("Lihat Informasi Lengkap"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}