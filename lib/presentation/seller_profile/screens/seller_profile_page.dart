import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/custom_button.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/bloc/seller_profile_bloc/seller_profile_bloc.dart';
import 'package:trade_loop/presentation/chat/screens/chat_page.dart';
import 'package:trade_loop/presentation/report/screen/report_type_page.dart';
import 'package:trade_loop/presentation/seller_profile/widgets/product_list_view.dart';
import 'package:trade_loop/presentation/seller_profile/widgets/seller_profile_img.dart';

class SellerProfilePage extends StatefulWidget {
  final String sellerId;
  final String currentUser;

  const SellerProfilePage({
    super.key,
    required this.sellerId,
    required this.currentUser,
  });

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<SellerProfileBloc>().add(FetchSellerProfile(widget.sellerId));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Seller Profile',
        backgroundColor: appbarColor,
        actions: [
          //Report Seller Section
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReportTypePage(
                            sellerId: widget.sellerId,
                            currentUserId: widget.currentUser,
                          )),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'report',
                child: Text('Report User'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Container(
        color: grey.shade200,
        child: BlocBuilder<SellerProfileBloc, SellerProfileState>(
          builder: (context, state) {
            if (state is SellerProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SellerProfileLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenWidth * 0.02),

                    // Seller Profile Section
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Row(
                        children: [
                          //Display Seller Image
                          SellerProfileImg(
                            size: screenWidth * 0.2,
                            imageUrl: state.seller.imagePath,
                          ),
                          SizedBox(width: screenWidth * 0.06),
                          //Display Seller Name
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              state.seller.name,
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Contact Seller Button
                    CustomButton(
                        label: 'Contact Seller',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    sellerId: widget.sellerId,
                                    currentUserId: widget.currentUser)),
                          );
                        }),
                    const SizedBox(height: 16.0),

                    const Divider(thickness: 2),

                    const SizedBox(height: 16.0),

                    // Product List Section
                    ProductListView(
                      products: state.products,
                      userId: widget.currentUser,
                    ),
                  ],
                ),
              );
            } else if (state is SellerProfileError) {
              return Center(child: CustomTextWidget(text: state.message));
            }
            return const Center(
                child: CustomTextWidget(text: 'No seller found.'));
          },
        ),
      ),
    );
  }
}
