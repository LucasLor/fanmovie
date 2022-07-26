import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/tmdAPI/model/keyword.dart';
import '../../services/tmdAPI/search_services.dart';
import '../../style/app_colors.dart';

class AutoCompleteSearchWidget extends StatefulWidget {
  const AutoCompleteSearchWidget({
    Key? key,
    required this.onSelect,
    required this.onChange,
  }) : super(key: key);

  final void Function(String) onSelect;
  final void Function(String) onChange;
  @override
  State<AutoCompleteSearchWidget> createState() =>
      _AutoCompleteSearchWidgetState();
}

class _AutoCompleteSearchWidgetState extends State<AutoCompleteSearchWidget> {
  SearchService ss = SearchService();
  Timer? _debounce;
  GlobalKey stickyKey = GlobalKey();
  
  Widget fieldViewBuilder(
      context, textEditingController, focusNode, void Function() onFieldSubmitted) {
    return Container(
      key: stickyKey,
      padding:const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
       decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: AppColors.surface),
      child: TextField(    
        style: TextStyle(color: AppColors.onSurface, fontSize: 20),
        decoration: InputDecoration(
            hintText: 'Pesquisar...',
            hintStyle: TextStyle(fontSize: 20, color: Colors.white24),
            border: InputBorder.none,            
            suffixIcon: IconButton(
              icon: Icon(
                Icons.search,
                color: AppColors.onSurface,
              ),
              onPressed: ()=> onFieldSubmitted(),
            )),            
        onChanged: widget.onChange,
        controller: textEditingController,
        focusNode: focusNode,        
      ),
    );
  }

  String displayStringForOption(Keyword option) {
    return option.name;
  }

  Future<Iterable<Keyword>> optionsBuilder(TextEditingValue textEditingValue) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (textEditingValue.text == '') {
      return const Iterable.empty();
    }

    var timerCompleter = Completer<List<Keyword>>();

    _debounce = Timer(const Duration(milliseconds: 200), () async {
     timerCompleter.complete(await ss.movieSuggest(textEditingValue.text));    
    });
  
    var results = await timerCompleter.future;
    return results.where((element) => element.name
      .toLowerCase()
      .contains(textEditingValue.text.toLowerCase()));

  }

  Widget optionsViewBuilder(BuildContext context, void Function(Keyword) onSelected, Iterable<Keyword> options){
      RenderBox textFieldBox = (stickyKey.currentContext?.findRenderObject() as RenderBox);
      return Align(
        alignment: Alignment.topLeft,
        child: Material(        
          color: Colors.transparent,          
          child: Container(
            width: textFieldBox.size.width,    
            height: MediaQuery.of(context).size.height*.7,        
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: AppColors.surface),
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final Keyword option = options.elementAt(index);
      
                return GestureDetector(
                  onTap: () {
                    onSelected(option);
                  },
                  child: ListTile(
                    title: Text(option.name,
                        style: TextStyle(color: AppColors.onSurface)),
                  ),
                );
              },
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Keyword>(            
      fieldViewBuilder: fieldViewBuilder,
      displayStringForOption: displayStringForOption,
      optionsBuilder: optionsBuilder,
      optionsViewBuilder: optionsViewBuilder,
      onSelected: (k) => widget.onSelect(k.name),       
    );    
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
