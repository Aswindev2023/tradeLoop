import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/presentation/bloc/tag_cubit/tag_cubit.dart';

class TagDropdownField extends StatelessWidget {
  final Function(List<String>) onTagsChanged;
  final List<String> initialTags;

  const TagDropdownField({
    super.key,
    required this.onTagsChanged,
    this.initialTags = const [],
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<TagCubit, List<String>>(
      listener: (context, state) {
        onTagsChanged(state);
      },
      child: BlocBuilder<TagCubit, List<String>>(
        builder: (context, selectedTags) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Tags",
                  border: OutlineInputBorder(),
                ),
                items: [
                  "Vintage",
                  "Furniture",
                  "Books",
                  "Fashion",
                  "Vehicles",
                  "Home Appliances",
                  "Sports",
                  "Toys",
                  "Mobiles",
                  "Laptops"
                ].map((tag) {
                  return DropdownMenuItem(
                    value: tag,
                    child: Text(tag),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<TagCubit>().addTag(value);
                  }
                },
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: selectedTags
                    .map((tag) => Chip(
                          label: Text(tag),
                          onDeleted: () {
                            context.read<TagCubit>().removeTag(tag);
                          },
                        ))
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
