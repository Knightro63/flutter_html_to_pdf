library flutter_html_to_pdf_web;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

import 'package:js/js.dart';
import 'dart:html';

@JS()
external void html2pdf1(html.Element element,String options, callback);

class FlutterHtmlToPdf {
  static Future<Uint8List?> convertHtmlToPdf(
    String htmlContent, {
      Size size = const Size(8.5,11),
      EdgeInsets margin = const EdgeInsets.all(1)
    }
  ) async {
    Completer<Uint8List?> c = Completer();

    html.Element toPrint = document.createElement('print');
    toPrint.setInnerHtml(htmlContent,validator: AllowAll());// .appendHtml(htmlContent);

    dynamic opt = {
      'margin':[margin.top*72, margin.left*72,margin.bottom*72,margin.right*72],
      'filename': 'myfile.pdf',
      'image':{ 'type': 'jpeg', 'quality': 1 },
      'html2canvas':{ 
        'scale': 1, 
        'letterRendering': true,
        'useCORS': true,
        'dpi': 192, 
      },
      'jsPDF':{'unit': 'pt', 'format': [size.height*72,size.width*72], 'orientation': 'portrait' },
      'pagebreak': { 'mode': ['avoid-all','css','legacy']}//,,'legacy''avoid-all',
      //'pagebreak': { , 'mode': "css", 'before': "#nextpage1", 'after': "1cm" }
      
    };

    var callback = allowInterop((data){
      c.complete(data);
    });

    html2pdf1(toPrint,jsonEncode(opt),callback);

    return c.future;
  }
}

class AllowAll implements NodeValidator {
    @override
    bool allowsAttribute(html.Element element, String attributeName, String value) {
       return true;
    }

    @override
    bool allowsElement(html.Element element) {
      return true;
    }
}