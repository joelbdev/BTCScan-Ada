package Options is

   type Options_Type is record
      Quick_Mode            : Boolean;
      Unicode_Only_Mode     : Boolean;
      Non_Unicode_Only_Mode : Boolean;
      Verbose               : Boolean;
   end record;

end Options;
