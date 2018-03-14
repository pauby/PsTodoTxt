## v1.1.1 01 March 2018

* Fixed bug where a todo file with blank lines would cause an error to be thrown;
## v1.1.0 29 January 2018

* Fixed a but where the views in PSTodoTxt.Format.ps1xml were being applied to all PSObjects. TodoTxt objects now have their own 'TodoTxt' object name;
* Added a Pester text to check for the new 'TodoTxt' objects being output from ConvertTo-TodoTxt function;
* Reformatted function help, comments and code to beautify, prettify and adhere to my own coding standards; 
* New build process puts code into .psm1 module script resulting in less to distribute / publish;

## v1.0.0 Initial Release