import 'package:flutter/material.dart';

class WeatherSettingsScreen extends StatefulWidget {
  const WeatherSettingsScreen({super.key});

  @override
  State<WeatherSettingsScreen> createState() => _WeatherSettingsScreenState();
}

class _WeatherSettingsScreenState extends State<WeatherSettingsScreen> {
  bool _useCurrentLocation = true;
  bool _showWeather = true;
  bool _customService = true;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt thời tiết'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Đơn vị'),
            trailing: Text('°C'),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Sử dụng vị trí hiện tại'),
            value: _useCurrentLocation,
            onChanged: (value) => setState(() => _useCurrentLocation = value),
            secondary: const Icon(Icons.location_on),
          ),
          const Divider(height: 1),
          const ListTile(
            title: Text('Tự động làm mới'),
            trailing: Text('Mỗi 6 giờ'),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Thông báo'),
            value: _notifications,
            onChanged: (value) => setState(() => _notifications = value),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Hiển thị Thời tiết trên màn hình Ứng dụng'),
            value: _showWeather,
            onChanged: (value) => setState(() => _showWeather = value),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Dịch vụ tùy chỉnh'),
            value: _customService,
            onChanged: (value) => setState(() => _customService = value),
          ),
          const Divider(height: 1),
          const ListTile(
            title: Text('Cài đặt chung'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(height: 1),
          const ListTile(
            title: Text('Thông tin Thời tiết'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
