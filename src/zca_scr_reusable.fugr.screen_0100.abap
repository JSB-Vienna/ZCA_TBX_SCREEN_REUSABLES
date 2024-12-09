* Process Before Output
PROCESS BEFORE OUTPUT.
  "Prepare screen data and layout
  MODULE d0000_pbo.

  "Set GUI status
  MODULE d0000_pbo_set_status.


* Process After Input
PROCESS AFTER INPUT.
  "Handle exit function codes
  MODULE d0000_pai_fcode AT EXIT-COMMAND.

  "Get cursor position
  MODULE d0000_pai_get_cursor.

  "Do checks and other things
  MODULE d0000_pai.

  "Handle function code
  MODULE d0000_pai_fcode.

