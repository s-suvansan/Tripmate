import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CountryPicker extends StatefulWidget {
  // final Function(CountryCodeModel) onSelect;
  final double? fontSize;
  const CountryPicker({Key? key, /* required this.onSelect, */ this.fontSize}) : super(key: key);

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  final List<CountryCodeModel> _countryCode = [
    CountryCodeModel(country: "Srilanka", flag: "assets/lk_flag.svg", code: "+94"),
  ];
  late CountryCodeModel _selectedCounrtyCode;

  @override
  void initState() {
    super.initState();
    _selectedCounrtyCode = _countryCode[0];
    // widget.onSelect(_selectedCounrtyCode);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => showCountryCode(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 8.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // app_.svgImage(svg: _selectedCounrtyCode.flag ?? "", height: 24.0, width: 24.0),
                  SvgPicture.asset(_selectedCounrtyCode.flag ?? "", height: 24.0, width: 24.0),
                  const SizedBox(width: 4.0),
                  Text(
                    "${_selectedCounrtyCode.code}",
                    // fontWeight: texts_.bold,
                  ),
                ],
              ),
              const SizedBox(height: 0.5),
            ],
          ),
          const SizedBox(width: 8.0),
          const SizedBox(
            height: 32.0,
            child: VerticalDivider(
              thickness: 1.0,
              width: 0.0,
            ),
          ),
          const SizedBox(width: 12.0),
        ],
      ),
    );
  }

  //  List<CountryCodeModel> get countryCode => _countryCode;
  // void showCountryCode(BuildContext context) {
  //   if (_countryCode.length > 1) {
  //     showModalBottomSheet(
  //         context: context,
  //         isScrollControlled: true,
  //         builder: (ctx) => _CountryCode(
  //               countryCodes: _countryCode,
  //             )).then((value) {
  //       if (value != null) {
  //         setState(() {
  //           _selectedCounrtyCode = value;
  //           widget.onSelect(_selectedCounrtyCode);
  //         });
  //         // getIt<UserProvider>().setSelectedCountryCode = value;
  //       }
  //     });
  //   }
  // }
}

class CountryCodeModel {
  CountryCodeModel({
    this.country,
    this.flag,
    this.code,
  });

  final String? country;
  final String? flag;
  final String? code;

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) => CountryCodeModel(
        country: json["country"] ?? "",
        flag: json["flag"] ?? "",
        code: json["code"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "flag": flag,
        "code": code,
      };
}


/* class _CountryCode extends StatelessWidget {
  final List<CountryCodeModel> countryCodes;

  const _CountryCode({Key? key, required this.countryCodes}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // height: 60.0,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: colors_.light,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              texts_.titleBold(
                text: "Select your country",
              ),
              // const SizedBox(width: 8.0),
              InkWell(
                  onTap: () => app_.popOnce(context),
                  child: Icon(
                    Icons.close,
                    color: colors_.shadowDark.withOpacity(0.5),
                  )),
            ],
          ),
        ),
        Divider(
          height: 0.0,
          color: colors_.shadow,
        ),
        ListView.separated(
          itemCount: countryCodes.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => Navigator.of(context).pop(countryCodes[index]),
              leading: app_.svgImage(
                svg: countryCodes[index].flag ?? "",
                height: 24.0,
              ),
              title: texts_.titleBold(text: countryCodes[index].country ?? ""),
            );
          },
          separatorBuilder: (ctx, i) => Divider(
            height: 0.0,
            color: colors_.shadow,
          ),
        ),
      ],
    );
  }
}
 */