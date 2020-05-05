class Pr{
  final String prId;
  final String prProductName;
  final String prProductCode;
  final String prProductPic;
  final String prProductStock;
  final String prProductQty;
  final String prProductUnit;
  final String prProductPrice;
  final String prProductCompany;
  final String prEmpScan;
  final String prDateScan;
  final String prPrintStatus;
  final String prPrintNo;
  final String prCheck;

  Pr({
    this.prId,
    this.prProductName,
    this.prProductCode,
    this.prProductPic,
    this.prProductStock,
    this.prProductQty,
    this.prProductUnit,
    this.prProductPrice,
    this.prProductCompany,
    this.prEmpScan,
    this.prDateScan,
    this.prPrintStatus,
    this.prPrintNo,
    this.prCheck
  });

  factory Pr.fromJson(Map<String, dynamic> json){
    return new Pr(
      prId: json['ID'],
      prProductName: json['Product_Name'],
      prProductCode: json['Product_Code'],
      prProductPic: json['pic'],
      prProductStock: json['Product_Stock'],
      prProductQty: json['Product_Qty'],
      prProductUnit: json['Product_Unit'],
      prProductPrice: json['Product_Price'],
      prProductCompany: json['Product_company'],
      prEmpScan: json['emp_Scan'],
      prDateScan: json['date_Scan'],
      prPrintStatus: json['Print_status'],
      prPrintNo: json['Print_No'],
      prCheck: json['pr_check'],
    );
  }
}