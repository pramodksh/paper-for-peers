import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';

class WebScrapingDemo extends StatefulWidget {
  @override
  _WebScrapingDemoState createState() => _WebScrapingDemoState();
}

class _WebScrapingDemoState extends State<WebScrapingDemo> {

  String text;

  String baseURL = "https://www.kud.ac.in";
  String fullURL = "https://www.kud.ac.in/cmsentities.aspx?type=notifications";
  // String baseURL = "https://www.newyorker.com";

  String notificationsURLPath = "/cmsentities.aspx?type=notifications";
  // String notificationsURLPath = "/magazine/2021/05/31/why-did-so-many-victorians-try-to-speak-with-the-dead?utm_source=pocket-newtab-intl-en";

  WebScraper webScraper = WebScraper();


  void foo() async {
    // print("URL: ${webScraper.baseUrl} | ${webScraper.timeElaspsed}");

    print("Loading URL");
    try {
      // bool isLoaded = await webScraper.loadWebPage(notificationsURLPath);
      bool isLoaded = await webScraper.loadFullURL(fullURL);
      // print(webScraper)
      if (isLoaded) {
        print("Web page loaded");
        // List<Map<String, dynamic>> elements = webScraper.getElement('h3.title > a.caption', ['href']);
        List<Map<String, dynamic>> elements = webScraper.getElement('td > table > tbody > tr', ['id']);
        // List<Map<String, dynamic>> elements = webScraper.getElement('td#main_context > table.tblContent', ['class']);
        for (var temp in elements) {
          log("\n\n\nTITLE: ${temp['title']} ||| CLASS ${temp['class']}\n\n\n");
        }
      } else {
        print("NOT LOADED");
      }
      print("DONE");
    } catch (e) {
      print("ERROR: ${e}");
    }
  }

  @override
  void initState() {
    // webScraper = WebScraper(baseURL);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    foo();

    return Scaffold(
      appBar: AppBar(
        title: Text("Web Scraping"),
        actions: [
          ElevatedButton(
            onPressed: () {
              print(webScraper.timeElaspsed);
            },
            child: Text("Time"),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
