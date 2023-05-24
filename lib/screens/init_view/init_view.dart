import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:stacked/stacked.dart';
import 'package:tripmate/common/brand_color.dart';
import 'package:tripmate/common/brand_text.dart';

import '../../common/country_picker.dart';
import '../../common/masked_input_formater.dart';
import 'init_view_model.dart';

class InitView extends StatelessWidget {
  static const routeName = "init_view";
  const InitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InitViewModel>.reactive(
        viewModelBuilder: () => InitViewModel(),
        builder: (context, model, _) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [Colors.indigo[900]!, Colors.indigo[800]!, Colors.indigo[400]!],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 60),
                      Image.asset(
                        'assets/logo_white.png',
                        height: 200.0,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: !model.isShowOtpView
                                  ? Column(
                                      children: <Widget>[
                                        const SizedBox(height: 40),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.indigo.withOpacity(0.2),
                                                    blurRadius: 5.0,
                                                    offset: const Offset(0, 10))
                                              ]),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            // decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
                                            child: Row(
                                              children: [
                                                const CountryPicker(),
                                                Expanded(
                                                  child: TextField(
                                                    controller: model.controller,
                                                    keyboardType: TextInputType.phone,
                                                    decoration: const InputDecoration(
                                                        hintText: "Phone number",
                                                        hintStyle: TextStyle(color: Colors.grey),
                                                        border: InputBorder.none),
                                                    inputFormatters: <TextInputFormatter>[
                                                      MaskedInputFormatter('## ### ####'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (model.mobileNumberError != null && model.mobileNumberError != "") ...[
                                          const SizedBox(height: 16.0),
                                          Row(
                                            children: [
                                              Text(
                                                model.mobileNumberError ?? "",
                                                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.normal),
                                              ),
                                            ],
                                          )
                                        ],
                                        const SizedBox(height: 80),
                                        GestureDetector(
                                          onTap: () => model.onContinue(context),
                                          child: Container(
                                            height: 50,
                                            margin: const EdgeInsets.symmetric(horizontal: 50),
                                            decoration:
                                                BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.indigo),
                                            child: const Center(
                                              child: Text(
                                                "Continue",
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 50),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Divider(
                                              color: Colors.grey.shade400,
                                              thickness: 1,
                                            )),
                                            const SizedBox(width: 8.0),
                                            Text(
                                              "OR",
                                              style: TextStyle(color: Colors.grey.shade500),
                                            ),
                                            const SizedBox(width: 8.0),
                                            Expanded(
                                                child: Divider(
                                              color: Colors.grey.shade400,
                                              thickness: 1,
                                            )),
                                          ],
                                        ),
                                        const SizedBox(height: 50),
                                        GestureDetector(
                                          onTap: () => model.onAnonymousLogin(context),
                                          child: Container(
                                            height: 50,
                                            margin: const EdgeInsets.symmetric(horizontal: 50),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50), color: Colors.grey.shade400),
                                            child: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.person_outline_outlined,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    "Login as Anonymous user",
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : _OtpView(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (model.isShowOtpView)
                  Positioned(
                    top: 10.0,
                    left: 20.0,
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: () => model.onBackToPhnNumberView(context),
                        child: const CircleAvatar(
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}

class _OtpView extends ViewModelWidget<InitViewModel> {
  @override
  Widget build(BuildContext context, InitViewModel viewModel) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Pinput(
          controller: viewModel.otpController,
          length: 6,
          defaultPinTheme: defaultPinTheme,
          showCursor: true,
          enableSuggestions: false,
          // validator: (value) => viewModel.pinValidation(value),
          // onChanged: (value) => viewModel.onPinType(value),
          onCompleted: (pin) => viewModel.onVerifyOtp(context, pin),
          autofocus: true,
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: () => viewModel.onContinue(context),
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.indigo),
            child: const Center(
              child: Text(
                "Resend OTP",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  final defaultPinTheme = PinTheme(
    width: 50.0,
    height: 50.0,
    textStyle: BrandTexts.textStyle(fontSize: 30.0, fontWeight: FontWeight.w400, color: BrandColors.brandColor),
    decoration: BoxDecoration(
      border: Border.all(color: BrandColors.brandColor),
      borderRadius: BorderRadius.circular(5.0),
    ),
  );
}
