import 'package:flutter/material.dart';

class TagDropdownField extends StatefulWidget {
  final Function(List<String>) onTagsChanged;
  final List<String>
      initialTags; // Added an optional parameter for initial tags

  const TagDropdownField(
      {super.key, required this.onTagsChanged, this.initialTags = const []});

  @override
  State<TagDropdownField> createState() => _TagDropdownFieldState();
}

class _TagDropdownFieldState extends State<TagDropdownField> {
  final List<String> _popularTags = [
    "Vintage",
    "Furniture",
    "Books",
    "Fashion",
    "Vehicles",
    "Home Appliances",
    "Sports",
    "Toys",
    "Mobiles",
    "Laptops",
    "Android",
    "Apple",
    "Women",
    "Men",
    "Children",
    "Headphones",
    "Smartwatches",
    "Tablets",
    "Gaming Consoles",
    "Cameras",
    "Shoes",
    "Accessories",
    "Jewelry",
    "Watches",
    "Decor",
    "Kitchen",
    "Office Furniture",
    "Lighting",
    "Bikes",
    "Cars",
    "Electric",
    "SUV",
    "Music",
    "Photography",
    "Fitness",
    "Outdoor"
  ];

  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _selectedTags = List<String>.from(widget.initialTags);
  }

  void _addTag(String tag) {
    if (!_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
        widget.onTagsChanged(_selectedTags);
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
      widget.onTagsChanged(_selectedTags);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "Tags",
            border: OutlineInputBorder(),
          ),
          items: _popularTags
              .map((tag) => DropdownMenuItem(
                    value: tag,
                    child: Text(tag),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) _addTag(value);
          },
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _selectedTags
              .map((tag) => Chip(
                    label: Text(tag),
                    onDeleted: () => _removeTag(tag),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
