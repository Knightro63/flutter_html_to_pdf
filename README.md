# flutter_html_to_pdf

[![pub package](https://img.shields.io/pub/v/flutter_html_to_pdf.svg)](https://pub.dartlang.org/packages/flutter_html_to_pdf)

Flutter plugin for generating PDF files from HTML

### Usage

```dart
var htmlContent =
"""
<!DOCTYPE html>
<html>
<head>
  <style>
  table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
  }
  th, td, p {
    padding: 5px;
    text-align: left;
  }
  </style>
</head>
  <body>
    <h2>PDF Generated with flutter_html_to_pdf plugin</h2>
    <table style="width:100%">
      <caption>Sample HTML Table</caption>
      <tr>
        <th>Month</th>
        <th>Savings</th>
      </tr>
      <tr>
        <td>January</td>
        <td>100</td>
      </tr>
      <tr>
        <td>February</td>
        <td>50</td>
      </tr>
    </table>
    <p>Image loaded from web</p>
    <img src="https://i.imgur.com/wxaJsXF.png" alt="web-img">
  </body>
</html>
""";

var targetPath = "/your/sample/path";
var targetFileName = "example_pdf_file"

var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
    htmlContent, targetPath, targetFileName);
```

Code above simply generates **PDF** file from **HTML** content. It should work with most of common HTML markers. You don’t need to add *.pdf* extension to ***targetFileName*** because plugin only generates PDF files and extension will be added automatically.
#### Other Usages
You can also pass ***File*** object with **HTML** content inside as parameter
```dart
var file = File("/sample_path/example.html");
var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlFile(
    file, targetPath, targetFileName);
```

or even just path to this file
```dart
var filePath = "/sample_path/example.html";
var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlFilePath(
    filePath, targetPath, targetFileName);
```

#### Images
If your want to add local image from device to your **HTML** you need to pass path to image as ***src*** value.

```html
<img src="file:///storage/example/your_sample_image.png" alt="web-img">
```
or if you want to use the image ***File*** object
```html
<img src="${imageFile.path}" alt="web-img">
```

Many images inside your document can significantly affect the final file size so I suggest to use [flutter_image_compress](https://github.com/OpenFlutter/flutter_image_compress) plugin.

#Web
For web please add the following code to your index.html page.

```html
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js" integrity="sha512vDKWohFHe2vkVWXHp3tKvIxxXg0pJxeid5eo+UjdjME3DBFBn2F8yWOE0XmiFcFbXxrEOR1JriWEno5Ckpn15A==" crossorigin="anonymous"></script>  

  <script type="text/javascript">
    function html2pdf1(element,options,callback){
      html2pdf()
      .from(element)
      .set(JSON.parse(options))
      .toPdf().output('blob').then(async (blob) => {
        var data = await new Response(blob).arrayBuffer();
        var uint = new Uint8Array(data);
        callback(uint);
      });
    }
  </script>
```


