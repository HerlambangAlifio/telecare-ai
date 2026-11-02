import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

Widget primaryButton(String label, VoidCallback onTap) => SizedBox(
  width: double.infinity,
  height: 52,
  child: FilledButton(
    onPressed: onTap,
    style: FilledButton.styleFrom(
      backgroundColor: blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
  ),
);

Widget panel({required Widget child, Color color = Colors.white}) => Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(17),
    border: Border.all(color: const Color(0xFFE0EAF5)),
  ),
  child: child,
);

Widget menuTile(
  BuildContext context,
  IconData icon,
  String title,
  String subtitle,
  VoidCallback action,
) => Padding(
  padding: const EdgeInsets.only(bottom: 13),
  child: InkWell(
    onTap: action,
    borderRadius: BorderRadius.circular(17),
    child: panel(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE5F2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: blue, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: blue),
        ],
      ),
    ),
  ),
);

class StepBanner extends StatelessWidget {
  final int step;

  const StepBanner({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    const labels = ['Isi Keluhan', 'Hasil AI', 'Konsultasi'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(3, (i) {
        return Expanded(
          child: Column(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: i + 1 <= step ? blue : const Color(0xFFE5ECF4),
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: i + 1 <= step ? Colors.white : Colors.blueGrey,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11,
                  color: i + 1 == step ? blue : Colors.blueGrey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

Widget section(String title, IconData icon, String body) => panel(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, color: blue),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: navy),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Text(body, style: const TextStyle(height: 1.5)),
    ],
  ),
);
