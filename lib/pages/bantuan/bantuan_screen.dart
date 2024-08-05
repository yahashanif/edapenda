import 'package:dapenda/app/constant.dart';
import 'package:dapenda/cubit/faq_cubit/faq_cubit.dart';
import 'package:dapenda/widgets/base_appbar.dart';
import 'package:dapenda/widgets/box_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../themes/themes.dart';
import '../../widgets/FaqShimmer.dart';

class BantuanScreen extends StatefulWidget {
  const BantuanScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BantuanBantuanScreenState createState() => _BantuanBantuanScreenState();
}

class _BantuanBantuanScreenState extends State<BantuanScreen> {
  // String labelfaq;

  getData() async {
    // context.read<FaqCubit>().getFaq()
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppbar(
        title: "Kembali",
        centerTitle: false,
        backgroundColor: blue,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Container(
                //   margin: EdgeInsets.only(left: 16, top: 24, right: 16),
                //   child: labelfaq != null
                //       ? Text(
                //           labelfaq,
                //           style: tahomaR.copyWith(
                //             fontSize: 18,
                //             color: Colors.black,
                //           ),
                //         )
                //       : TextShimmer2(),
                // ),
                const BoxGap(
                  height: 16,
                ),
                BlocBuilder<FaqCubit, FaqState>(
                  builder: (context, state) {
                    if (state is FaqLoaded) {
                      return SizedBox(
                        width: double.infinity,
                        height: getActualY(y: 800, context: context),
                        child: ListView.builder(
                          itemCount: state.list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Colors.grey[200],
                              child: ExpansionTile(
                                initiallyExpanded: index == 0,
                                title: Text(
                                  state.list[index].tanya ?? '',
                                  style: tahomaB.copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                children: <Widget>[
                                  Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.only(top: 8, bottom: 8),
                                    child: ListTile(
                                      title: Text(
                                        state.list[index].jawab ?? '',
                                        style: tahomaR.copyWith(
                                          fontSize: 16,
                                          color: const Color(0XFF606060),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is FaqLoading) {
                      return const Column(
                        children: <Widget>[
                          FaqShimmer(),
                          FaqShimmer(),
                          FaqShimmer(),
                        ],
                      );
                    } else if (state is FaqFailed) {
                      return Center(
                          child: Column(
                        children: [
                          const Icon(Icons.refresh, color: Colors.grey),
                          Text(
                            state.error,
                            style: tahomaR.copyWith(
                              fontSize: 16,
                              color: const Color(0XFF606060),
                            ),
                          )
                        ],
                      ));
                    }
                    return const BoxGap();
                  },
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.15),
              child: Text(
                'Butuh Bantuan ?',
                style: tahomaB.copyWith(
                  fontSize: 18,
                  color: Color(0XFF28166F),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 16, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => launch("tel://021 5505399"),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/black.png'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Telp : 021 5505399',
                    textAlign: TextAlign.center,
                    style: robotoM.copyWith(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: 16, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _launchUrl(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/icons8-whatsapp-96.png'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'WA : 08111162801',
                    textAlign: TextAlign.center,
                    style: robotoM.copyWith(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

_launchUrl() async {
  const url = 'https://api.whatsapp.com/send?phone=628111162801&text=Halo';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
