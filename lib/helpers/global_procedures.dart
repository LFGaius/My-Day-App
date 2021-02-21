class GlobalProcedures{
  static String getDateWithMoreText(String date){
    List<String> date_splited=date.split('-');
    int month=int.parse(date_splited[1]);
    String day=date_splited[0],year=date_splited[2];
    switch(month){
      case 1:return '${day} Jan ${year}';
      case 2:return '${day} Feb ${year}';
      case 3:return '${day} Mar ${year}';
      case 4:return '${day} Apr ${year}';
      case 5:return '${day} May ${year}';
      case 6:return '${day} Jun ${year}';
      case 7:return '${day} Jul ${year}';
      case 8:return '${day} Aug ${year}';
      case 9:return '${day} Sep ${year}';
      case 10:return '${day} Oct ${year}';
      case 11:return '${day} Nov ${year}';
      case 12:return '${day} Dec ${year}';
    }
  }
}