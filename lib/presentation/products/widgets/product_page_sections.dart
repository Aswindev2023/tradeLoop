import 'package:flutter/material.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/presentation/products/widgets/custom_textformfield.dart';
import 'package:trade_loop/presentation/products/widgets/product_image_picker.dart';
import 'package:trade_loop/presentation/profile/widgets/custom_tile_widget.dart';

//Image Section
class ProductImageSection extends StatelessWidget {
  final Function(List<String>) onImagesPicked;
  final List<String> initialImages;

  const ProductImageSection({
    required this.onImagesPicked,
    this.initialImages = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: grey200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: grey[300]!),
      ),
      child: Column(
        children: [
          const Text("Product Images",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ProductImagePicker(
            onImagesPicked: onImagesPicked,
            initialImages: initialImages,
          ),
        ],
      ),
    );
  }
}

//Product Details Section
class ProductPageDetailsSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController conditionController;

  const ProductPageDetailsSection({
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.conditionController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
            controller: nameController,
            label: "Product Name",
            validator: (value) => value!.isEmpty ? "Enter product name" : null),
        const SizedBox(height: 16),
        CustomTextFormField(
            controller: descriptionController,
            label: "Description",
            maxLines: 3,
            validator: (value) =>
                value!.isEmpty ? "Enter product description" : null),
        const SizedBox(height: 16),
        CustomTextFormField(
            controller: priceController,
            label: "Price",
            validator: (value) =>
                value == null || value.isEmpty ? "Please enter a price" : null),
        const SizedBox(height: 16),
        CustomTextFormField(
            controller: conditionController,
            label: "Condition (e.g., New, Used)",
            validator: (value) => value!.isEmpty ? "Specify condition" : null),
      ],
    );
  }
}

//Availability Section
class ProductAvailabilitySection extends StatelessWidget {
  final bool isAvailable;
  final Function(bool) onAvailabilityChanged;

  const ProductAvailabilitySection(
      {required this.isAvailable,
      required this.onAvailabilityChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text("Available"),
      value: isAvailable,
      onChanged: onAvailabilityChanged,
    );
  }
}

//Location Section
class ProductLocationSection extends StatelessWidget {
  final String locationName;
  final VoidCallback onLocationSelected;

  const ProductLocationSection(
      {required this.locationName,
      required this.onLocationSelected,
      super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTileWidget(
      title: locationName.isEmpty ? "No location selected" : locationName,
      onTap: onLocationSelected,
      customFontWeight: FontWeight.w400,
    );
  }
}

//Add Or Edit product button
class ProductPageButtonSection extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String title;

  const ProductPageButtonSection({
    required this.onPressed,
    required this.isLoading,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWeb = constraints.maxWidth > 600;
            return ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWeb ? 120 : 80,
                    vertical: isWeb ? 19 : 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: productButtonCol,
                  elevation: 8,
                  shadowColor: green.withOpacity(0.5),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: whiteColor,
                        strokeWidth: 2,
                      )
                    : CustomTextWidget(
                        text: title,
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ));
          },
        ),
      ),
    );
  }
}
