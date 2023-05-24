import 'package:flutter/material.dart';
import 'package:tripmate/common/brand_color.dart';
import 'package:tripmate/common/brand_text.dart';

class CommonPopup extends StatelessWidget {
  final String? text;
  final String? desc;
  final bool needDoubleButton;
  final String? yesText;
  final String? noText;
  final String? okText;

  const CommonPopup({
    Key? key,
    this.text = "",
    this.desc = "",
    this.needDoubleButton = true,
    this.yesText,
    this.noText,
    this.okText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 52.0),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                if (text != null && text != "")
                  Text(
                    text ?? "",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: BrandTexts.textStyle(
                      color: BrandColors.brandColor,
                      fontSize: 16.0,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                /*  if (text != null && text != "")
                  Divider(
                    color: BrandColors.shadow,
                  ), */
                if (text != null && text != "") const SizedBox(height: 16.0),
                if (desc != null && desc != "")
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        desc ?? "",
                        maxLines: 50,
                        textAlign: TextAlign.center,
                        style: BrandTexts.textStyle(
                          color: BrandColors.brandColor,
                          fontSize: 16.0,
                          letterSpacing: 0.5,
                        ),
                      )),
                if (desc != null && desc != "") const SizedBox(height: 8.0),
                const Divider(color: Colors.grey),
                needDoubleButton ? _doubleButton(context) : _singleButton(context),
              ],
            )),
      ],
    );
  }

  Widget _doubleButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text(
              yesText ?? "Yes",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: BrandTexts.textStyle(
                color: BrandColors.brandColor,
                fontSize: 16.0,
                letterSpacing: 0.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(
            height: 20.0,
            child: VerticalDivider(
              color: Colors.grey,
            )),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text(
              noText ?? "No",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: BrandTexts.textStyle(
                color: BrandColors.brandColor,
                fontSize: 16.0,
                letterSpacing: 0.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _singleButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text(
              noText ?? "No",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: BrandTexts.textStyle(
                color: BrandColors.brandColor,
                fontSize: 16.0,
                letterSpacing: 0.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
