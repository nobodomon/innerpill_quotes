import 'package:flutter/material.dart';
import 'package:innerpill_quotes/authentication_service.dart';

class CommonSplitTabs extends StatefulWidget {
  CommonSplitTabs(
      {this.auth, this.logoutCallback, this.pages, this.viewportFraction});
  final AuthenticationService auth;
  final VoidCallback logoutCallback;
  final List<Widget> pages;
  final double viewportFraction;
  @override
  _CommonSplitTabsState createState() => _CommonSplitTabsState();
}

class _CommonSplitTabsState extends State<CommonSplitTabs>
    with SingleTickerProviderStateMixin {
  PageController controller;
  TabController tabController;

  @override
  void initState() {
    controller = PageController(viewportFraction: widget.viewportFraction);
    tabController = TabController(
      vsync: this,
      length: widget.pages.length,
    );
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        indicatorColor: Colors.purpleAccent.shade700,
        labelColor: Colors.purpleAccent.shade700,
        unselectedLabelColor: Colors.purple.shade100,
        controller: tabController,
        onTap: ((int x) {
          controller.animateToPage(x,
              duration: Duration(milliseconds: 5), curve: Curves.easeInCubic);
          tabController.animateTo(x,
              duration: Duration(milliseconds: 5), curve: Curves.easeInCubic);
        }),
        tabs: [
          Tab(
            child: Text("Quote"),
          ),
          Tab(
            child: Text("Passage"),
          )
        ],
      ),
      body: PageView(
        controller: controller,
        onPageChanged: ((int x) {
          controller.animateToPage(x,
              duration: Duration(milliseconds: 5), curve: Curves.easeInCubic);
          tabController.animateTo(x,
              duration: Duration(milliseconds: 5), curve: Curves.easeInCubic);
        }),
        children: widget.pages,
      ),
    );
  }
}
