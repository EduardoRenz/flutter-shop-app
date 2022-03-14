// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product_list.dart';
import '../models/product.dart';
import '../utils/CurrencyInputFormatter.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({Key? key}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final TextEditingController _imageUrlController = TextEditingController();
  final _imageURLFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  void _onImageUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    _imageURLFocus.addListener(_onImageUpdate);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)!.settings.arguments;

      if (arg != null) {
        final product = arg as Product;

        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    _imageURLFocus.removeListener(_onImageUpdate);
    _imageURLFocus.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<ProductList>(context, listen: false)
          .saveProduct(_formData);

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double? _toDouble(String value) {
    if (value.isEmpty) {
      return 0;
    }
    String onlyNumbers = value.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(onlyNumbers)! / 100;
  }

  String? _validatePrice(String? price) {
    return price!.trim().isEmpty ||
            _toDouble(price) == null ||
            _toDouble(price)! <= 0
        ? 'A valid price is required'
        : null;
  }

  bool _isValidImageURL(String url) {
    final VALID_IMAGE_EXTENSIONS = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
    ];

    bool isValidUR = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool isValidImage = VALID_IMAGE_EXTENSIONS
        .any((extension) => url.toLowerCase().endsWith(extension));

    return isValidUR && isValidImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Form'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                  key: _formKey,
                  child: ListView(children: [
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
                      decoration: const InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                      onSaved: (name) => _formData['name'] = name ?? '',
                      validator: (_name) =>
                          _name!.trim().isEmpty || _name.trim().length < 3
                              ? 'A valid name is required'
                              : null,
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      decoration: const InputDecoration(
                          labelText: 'Price', prefixText: 'R\$'),
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onSaved: (price) => _formData['price'] = _toDouble(price!)
                          as Object, // double.tryParse(price!) ?? 0,
                      validator: _validatePrice,
                      //onChanged: (value) => _formatPrice(value),
                      inputFormatters: [
                        CurrencyInputFormatter(),
                      ],
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (description) =>
                          _formData['description'] = description ?? '',
                      validator: (_description) =>
                          _description!.trim().isEmpty ||
                                  _description.trim().length < 3
                              ? 'A valid description is required'
                              : null,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imageURLFocus,
                            onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (imageUrl) =>
                                _formData['imageUrl'] = imageUrl ?? '',
                            validator: (_imageURL) =>
                                _isValidImageURL(_imageURL ?? '')
                                    ? null
                                    : 'A valid image URL is required',
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Image Preview')
                              : Image.network(_imageUrlController.text),
                        )
                      ],
                    ),
                  ])),
            ),
    );
  }
}
