import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: "",
    title: "",
    description: "",
    imageUrl: "",
    price: 0,
  );

  var _isInit = true;
  var _isLoading = false;

  var _initProduct = {
    'id': '',
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': '',
  };

  @override
  void initState() {
    _imageURLFocusNode.addListener(_imageUrlPreview);
    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLController.dispose();
    _imageURLFocusNode.dispose();
    // _imageURLFocusNode.removeListener(_imageUrlPreview);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    if (_isInit && productId.isNotEmpty) {
      _editedProduct = Provider.of<Products>(context).getProductById(productId);

      _initProduct = {
        'id': _editedProduct.id,
        'title': _editedProduct.title,
        'price': _editedProduct.price.toString(),
        'description': _editedProduct.description,
        'imageUrl': '',
      };
      _imageURLController.text = _editedProduct.imageUrl;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _imageUrlPreview() {
    final value = _imageURLController.text;

    if ((!value.startsWith("https") && !value.startsWith("http")) ||
        (!value.endsWith(".jpg") &&
            !value.endsWith(".png") &&
            !value.endsWith(".jpeg"))) {
      return;
    }

    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveFormData() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id.isNotEmpty) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        print("Catched error");
        await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("There is an error!"),
              content: Text("Something went wrong!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("Okay"))
              ],
            );
          },
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveFormData,
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator.adaptive())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                          initialValue: _initProduct['title'],
                          decoration: InputDecoration(labelText: "Title"),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value!,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter title ';
                            }
                            return null;
                          }),
                      TextFormField(
                        initialValue: _initProduct['price'],
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value!),
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter price.";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter number.";
                          }

                          if (double.parse(value) <= 0) {
                            return "Invalid Price";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initProduct['description'],
                        decoration: InputDecoration(labelText: "Description"),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value!,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter description";
                          }
                          if (value.length < 10) {
                            return "Please write description more than 10 characters.";
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            child: Card(
                              elevation: 10,
                              child: _imageURLController.text.isNotEmpty
                                  ? Image.network(
                                      _imageURLController.text,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Text("No preview"),
                                    ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Image URL"),
                              textInputAction: TextInputAction.done,
                              controller: _imageURLController,
                              focusNode: _imageURLFocusNode,
                              onFieldSubmitted: (_) {
                                _saveFormData();
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  imageUrl: value!,
                                  price: _editedProduct.price,
                                  isFavorite: _editedProduct.isFavorite,
                                );
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Image URL";
                                } else if (!value.startsWith("https") &&
                                    !value.startsWith("http")) {
                                  return "Invalid URL";
                                } else if (!value.endsWith(".jpg") &&
                                    !value.endsWith(".png") &&
                                    !value.endsWith(".jpeg")) {
                                  return "Invalid Image format";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: _saveFormData,
                          child: Text("Submit"),
                        ),
                      )
                    ],
                  )),
            ),
    );
  }
}
