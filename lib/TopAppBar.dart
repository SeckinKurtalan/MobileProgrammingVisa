// ignore_for_file: implementation_imports, unnecessary_import, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TopAppBar extends StatefulWidget {
  const TopAppBar({super.key, required this.PageName});
  final String PageName;
  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  @override
  Widget build(BuildContext context) {
    var ResponsiveWidth = MediaQuery.of(context).size.width;
    var ResponsiveHeight = MediaQuery.of(context).size.height;
    return Container(
      height: widget.PageName.contains("Favorites")
          ? ResponsiveHeight * 0.22
          : ResponsiveHeight * 0.28,
      width: ResponsiveWidth,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
            top: ResponsiveHeight * 0.15,
            left: ResponsiveWidth * 0.02,
            right: ResponsiveWidth * 0.02,
            bottom: ResponsiveHeight * 0.01),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.PageName,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              )),
          const Spacer(),
          widget.PageName.contains("Favorites")
              ? const SizedBox.shrink()
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200,
                  ),
                  child: SizedBox(
                    height: ResponsiveHeight * 0.05,
                    width: ResponsiveWidth,
                    child: TextField(
                        //controller: widget.searchedText,
                        //textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          top: 1.69420, bottom: 0, left: 0, right: 0),
                      hintText: 'Search for the games',
                      hintStyle:
                          const TextStyle(fontSize: 18, color: Colors.grey),
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 25,
                        color: Colors.grey,
                      ),
                      constraints: BoxConstraints(
                          maxWidth: ResponsiveWidth * 0.9,
                          maxHeight: ResponsiveHeight * 0.06),
                    )),
                  ),
                )
        ]),
      ),
    );
  }
}
