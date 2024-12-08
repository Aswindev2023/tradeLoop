import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/custom_appbar.dart';
import 'package:trade_loop/core/utils/custom_button.dart';
import 'package:trade_loop/presentation/bloc/seller_profile_bloc/seller_profile_bloc.dart';
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
        backgroundColor: const Color.fromARGB(255, 35, 17, 239),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                // Handle "Report User" action
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
        color: Colors.grey.shade200,
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
                          SellerProfileImg(
                            size: screenWidth * 0.2,
                            imageUrl: state.seller.imagePath,
                          ),
                          SizedBox(width: screenWidth * 0.06),
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
                    CustomButton(label: 'Contact Seller', onTap: () {}),
                    const SizedBox(height: 16.0),

                    // Divider
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
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No seller found.'));
          },
        ),
      ),
    );
  }
}
