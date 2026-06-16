import 'package:flutter/material.dart';
import 'package:smartbins/core/app_colors.dart';


class PhotoUpload extends StatefulWidget {
  const PhotoUpload({super.key});

  @override
  State<PhotoUpload> createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  bool _hasPhoto = false;

  void _pickPhoto() {
    setState(() => _hasPhoto = !_hasPhoto);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Upload button
        GestureDetector(
          onTap: _pickPhoto,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.lightGray,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.gray.withOpacity(0.5),
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  'UPLOAD',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gray.withOpacity(0.5),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Photo preview (shows when uploaded)
        if (_hasPhoto)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/images/dark_bin.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }
}