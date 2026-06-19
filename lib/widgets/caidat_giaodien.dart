import 'package:flutter/material.dart';
import '../models/data_store.dart';

class CaidatGiaodien extends StatelessWidget {
  const CaidatGiaodien({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tùy Chỉnh Giao Diện')),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: DataStore.themeNotifier,
        builder: (context, currentMode, child) {
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                child: SwitchListTile(
                  secondary: Icon(
                    currentMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Colors.orange,
                  ),
                  title: const Text('Chế độ Nền Tối (Dark Mode)'),
                  subtitle: const Text('Bật tắt giao diện sáng tối hệ thống'),
                  value: currentMode == ThemeMode.dark,
                  onChanged: (laGiaoDienToi) {
                    DataStore.themeNotifier.value =
                        laGiaoDienToi ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
