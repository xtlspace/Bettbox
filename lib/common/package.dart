import 'package:package_info_plus/package_info_plus.dart';

extension PackageInfoExtension on PackageInfo {
  String get ua => ['ClashMetaForAndroid/2.11.30.Meta'].join(' ');
}
