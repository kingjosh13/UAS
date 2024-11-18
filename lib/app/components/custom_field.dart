import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../constants/app_font.dart';

class CustomField extends StatelessWidget {
  final String? label; // Mengubah label menjadi nullable
  final TextInputType inputType;
  final TextEditingController? controller;
  final String? suffixText;
  final ValueChanged<String>? onChanged; // Menambahkan parameter onChanged
  final int maxLine;

  const CustomField({
    super.key,
    this.label, // Menambahkan label sebagai parameter nullable
    this.controller,
    this.inputType = TextInputType.text,
    this.suffixText,
    this.onChanged, // Menambahkan parameter onChanged
    this.maxLine = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Agar label di atas textfield
        children: [
          // Menampilkan label jika tidak null
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                label ?? '',
                style: AppFont.medium.copyWith(
                  fontSize: 16,
                  color: AppColor.white,
                ),
              ),
            ),

          // TextFormField yang sudah terintegrasi onChanged dan label
          TextFormField(
            cursorColor: AppColor.purple1,
            textCapitalization: TextCapitalization.words,
            controller: controller,
            keyboardType: inputType,
            style: AppFont.medium.copyWith(
              fontSize: 16,
              color: AppColor.white,
            ),
            onChanged: onChanged, // Menyambungkan fungsi onChanged
            maxLines: maxLine,
            decoration: InputDecoration(
              hintText: 'Input Your ${label ?? "Name"}',
              hintStyle: AppFont.medium.copyWith(
                fontSize: 16,
                color: AppColor.grey1,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: AppColor.grey1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: AppColor.grey1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColor.purple1,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18.0,
                horizontal: 14.0,
              ),
              fillColor: AppColor.purple3,
              filled: true,
              suffixText: suffixText, // Menambahkan suffixText jika ada
            ),
          ),
        ],
      ),
    );
  }
}
