import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final int commentsCount;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onLink;
  final Animation<double>? animation;

  const ItemCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.commentsCount,
    required this.onTap,
    required this.onLike,
    required this.onComment,
    required this.onLink,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- GAMBAR ---
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 16 / 9, // Rasio gambar widescreen
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),

              // --- TEXT & TOMBOL ---
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: onLike,
                              icon: const Icon(Icons.favorite_border, color: Colors.teal),
                              tooltip: 'Like',
                            ),
                            IconButton(
                              onPressed: onComment,
                              icon: const Icon(Icons.comment_outlined, color: Colors.blueGrey),
                              tooltip: 'Comment',
                            ),
                            Text(
                              "$commentsCount",
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        TextButton.icon(
                          onPressed: onLink,
                          icon: const Icon(Icons.info_outline, size: 18),
                          label: const Text('Info'),
                          style: TextButton.styleFrom(foregroundColor: Colors.teal),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Jika ada animasi, bungkus card dengan animasi
    if (animation != null) {
      return FadeTransition(
        opacity: animation!,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
              .animate(animation!),
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}