import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => HomeViewModel(),
        builder: (context, model, _) {
          return Scaffold(
            body: Column(
              children: [
                _Nametext(),
                ElevatedButton(
                  onPressed: () => model.chageName(),
                  child: const Text("change"),
                )
              ],
            ),
          );
        });
  }
}

class _Nametext extends ViewModelWidget<HomeViewModel> {
  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Text(viewModel.name);
  }
}
