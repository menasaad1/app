import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';

import '../../features/bishops/domain/entities/bishop.dart';
import '../utils/date_formatter.dart';

class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  Future<String> exportToPdf(List<Bishop> bishops, String fileName) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildPdfHeader(),
            pw.SizedBox(height: 20),
            _buildPdfTable(bishops),
            pw.SizedBox(height: 20),
            _buildPdfFooter(),
          ];
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName.pdf');
    await file.writeAsBytes(await pdf.save());
    
    return file.path;
  }

  pw.Widget _buildPdfHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.green100,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'تقرير الأساقفة',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'تاريخ التقرير: ${DateFormatter.formatDate(DateTime.now())}',
            style: pw.TextStyle(
              fontSize: 14,
              color: PdfColors.green700,
            ),
          ),
          pw.Text(
            'إجمالي الأساقفة: ${bishops.length}',
            style: pw.TextStyle(
              fontSize: 14,
              color: PdfColors.green700,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfTable(List<Bishop> bishops) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.5),
      },
      children: [
        _buildPdfTableHeader(),
        ...bishops.map((bishop) => _buildPdfTableRow(bishop)).toList(),
      ],
    );
  }

  pw.TableRow _buildPdfTableHeader() {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      children: [
        _buildPdfTableCell('الاسم', isHeader: true),
        _buildPdfTableCell('اللقب', isHeader: true),
        _buildPdfTableCell('الأبرشية', isHeader: true),
        _buildPdfTableCell('تاريخ الرسامة', isHeader: true),
        _buildPdfTableCell('تاريخ الميلاد', isHeader: true),
      ],
    );
  }

  pw.TableRow _buildPdfTableRow(Bishop bishop) {
    return pw.TableRow(
      children: [
        _buildPdfTableCell(bishop.name),
        _buildPdfTableCell(bishop.title),
        _buildPdfTableCell(bishop.diocese),
        _buildPdfTableCell(DateFormatter.formatDate(bishop.ordinationDate)),
        _buildPdfTableCell(DateFormatter.formatDate(bishop.birthDate)),
      ],
    );
  }

  pw.Widget _buildPdfTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildPdfFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      child: pw.Text(
        'تم إنشاء هذا التقرير بواسطة تطبيق إدارة الأساقفة',
        style: pw.TextStyle(
          fontSize: 10,
          color: PdfColors.grey600,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  Future<String> exportToExcel(List<Bishop> bishops, String fileName) async {
    final excel = Excel.createExcel();
    final sheet = excel['الأساقفة'];

    // Headers
    sheet.cell(CellIndex.indexByString('A1')).value = const TextCellValue('الاسم');
    sheet.cell(CellIndex.indexByString('B1')).value = const TextCellValue('اللقب');
    sheet.cell(CellIndex.indexByString('C1')).value = const TextCellValue('الأبرشية');
    sheet.cell(CellIndex.indexByString('D1')).value = const TextCellValue('تاريخ الرسامة');
    sheet.cell(CellIndex.indexByString('E1')).value = const TextCellValue('تاريخ الميلاد');
    sheet.cell(CellIndex.indexByString('F1')).value = const TextCellValue('رقم الهاتف');
    sheet.cell(CellIndex.indexByString('G1')).value = const TextCellValue('البريد الإلكتروني');
    sheet.cell(CellIndex.indexByString('H1')).value = const TextCellValue('العنوان');

    // Data
    for (int i = 0; i < bishops.length; i++) {
      final bishop = bishops[i];
      final rowIndex = i + 2;
      
      sheet.cell(CellIndex.indexByString('A$rowIndex')).value = TextCellValue(bishop.name);
      sheet.cell(CellIndex.indexByString('B$rowIndex')).value = TextCellValue(bishop.title);
      sheet.cell(CellIndex.indexByString('C$rowIndex')).value = TextCellValue(bishop.diocese);
      sheet.cell(CellIndex.indexByString('D$rowIndex')).value = TextCellValue(DateFormatter.formatDate(bishop.ordinationDate));
      sheet.cell(CellIndex.indexByString('E$rowIndex')).value = TextCellValue(DateFormatter.formatDate(bishop.birthDate));
      sheet.cell(CellIndex.indexByString('F$rowIndex')).value = TextCellValue(bishop.phoneNumber ?? '');
      sheet.cell(CellIndex.indexByString('G$rowIndex')).value = TextCellValue(bishop.email ?? '');
      sheet.cell(CellIndex.indexByString('H$rowIndex')).value = TextCellValue(bishop.address ?? '');
    }

    // Auto-fit columns
    for (int i = 1; i <= 8; i++) {
      sheet.setColumnWidth(i, 20);
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName.xlsx');
    await file.writeAsBytes(excel.encode()!);
    
    return file.path;
  }

  Future<void> printReport(List<Bishop> bishops) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildPdfHeader(),
            pw.SizedBox(height: 20),
            _buildPdfTable(bishops),
            pw.SizedBox(height: 20),
            _buildPdfFooter(),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> openFile(String filePath) async {
    await OpenFile.open(filePath);
  }

  Future<String> getExportDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<List<String>> getExportedFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync()
        .where((file) => file.path.endsWith('.pdf') || file.path.endsWith('.xlsx'))
        .map((file) => file.path)
        .toList();
    return files;
  }

  Future<void> deleteExportedFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> shareFile(String filePath) async {
    // TODO: Implement file sharing
    // This would require additional packages like share_plus
  }
}

