## v1.1.0 29 January 2018

* Fixed a but where the views in PSTodoTxt.Format.ps1xml were being applied to all PSObjects. TodoTxt objects now have their own 'TodoTxt' object name;
* Added a Pester text to check for the new 'TodoTxt' objects being output from ConvertTo-TodoTxt function;
* Reformatted function help, comments and code to beautify, prettify and adhere to my own coding standards; 
* New build process puts code into .psm1 module script resulting in less to distribute / publish;

## v1.0.0 Initial Release