import 'package:flutter/material.dart';
class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;


  const SearchWidget({Key? key, required this.text, required this.onChanged, required this.hintText}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
 final controler = TextEditingController();
 final styleActive = const TextStyle(color:Colors.black);
 final styleHint = const TextStyle(color:Colors.black54);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controler,
        enableSuggestions: true,
        decoration: InputDecoration(
          icon: const Icon(Icons.search,color: Colors.black,),
          suffixIcon: widget.text.isNotEmpty ?
              GestureDetector(
                child: const Icon(Icons.close,color: Colors.black26,),
                onTap: (){
                  controler.clear();
                  widget.onChanged('');
                  FocusScope.of(context).nextFocus();
                },
              ):null,
          hintText: widget.hintText,
          hintStyle: widget.text.isEmpty ? styleHint: styleActive,
          border: InputBorder.none
        ),
        style: widget.text.isEmpty ? styleHint: styleActive,
        onChanged: widget.onChanged,
      ),
    );
  }
}
