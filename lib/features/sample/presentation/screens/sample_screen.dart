import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/custom_app_bar.dart';


class SampleScreen extends StatefulWidget {
  const SampleScreen({super.key});

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolBar(title: "Sample App", showBackButton: false,),
      body: SafeArea(child: Center(child: Text("App contents will go here..."))),
    );
  }
}
