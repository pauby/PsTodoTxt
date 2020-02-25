## 1.3.0 25 February 2020
* added function ConvertTo-TodoTxtDate to return a date in the TodoTxt format. No more having to convert those dates manually (and maybe wrongly!);

## 1.2.1 13 February 2020
* Fixed some filename casing issues that only appeared in Linux (Linux is case sensitive!);

## v1.2.0 7 August 2018
* Added new `-ParseOnly` parameter to ConvertTo-TodoTxt to only parse the todo text and not validate it;
* Made the Get-TodoTxtTodaysDate function public;

## v1.1.1 01 March 2018
* Fixed bug where a todo file with blank lines would cause an error to be thrown;

## v1.1.0 29 January 2018
* Fixed a but where the views in PSTodoTxt.Format.ps1xml were being applied to all PSObjects. TodoTxt objects now have their own 'TodoTxt' object name;
* Added a Pester text to check for the new 'TodoTxt' objects being output from ConvertTo-TodoTxt function;
* Reformatted function help, comments and code to beautify, prettify and adhere to my own coding standards; 
* New build process puts code into .psm1 module script resulting in less to distribute / publish;

## v1.0.0 Initial Release