import 'package:fanmovie/style/app_colors.dart';
import 'package:fanmovie/views/page/home_page.dart';
import 'package:fanmovie/views/page/search_page.dart';
import 'package:flutter/material.dart';

class MainBottonTabNav extends StatefulWidget {
  const MainBottonTabNav({Key? key}) : super(key: key);

  @override
  State<MainBottonTabNav> createState() => _MainBottonTabNavState();
}

enum MainTabs {
  home,
  search
}

class _MainBottonTabNavState extends State<MainBottonTabNav> {
  int currentIndex = 0;
  var globalKey = GlobalKey<State<BottomNavigationBar>>(); // Global key usada para navegaçao entre telas a partir de uma page
  List<Widget> screens = [];

  @override
  void initState() {    
    super.initState();
    screens.add(HomePage(navigateTo: onPageRequestChangeTab));
    screens.add(SearchPage());
  }

  /// Utiliza GlobalKey para fazer navegação entre tabs
  void onPageRequestChangeTab(MainTabs tab ){
    BottomNavigationBar navigationBar = globalKey.currentWidget as BottomNavigationBar;
    if(navigationBar.onTap != null){
      navigationBar.onTap!(1);
    }
  }

  void setCurrentIndex(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  Widget _body() {
    return IndexedStack(
      index: currentIndex,
      children: screens,
    );
  }

  Widget _bottonNavigationBar() {
    return BottomNavigationBar(
      key: globalKey,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      backgroundColor: AppColors.secondary,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.onSurface,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      iconSize: 30,
      onTap: setCurrentIndex,
      items: const [
         BottomNavigationBarItem(
            icon:  Icon(Icons.home), label: 'Home'),
         BottomNavigationBarItem(
            icon: Icon(Icons.search), label: 'Find'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      bottomNavigationBar: _bottonNavigationBar(),
    );
  }
}
