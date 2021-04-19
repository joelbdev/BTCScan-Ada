package body Always_True is
   function Validate_Always_True (S : String) return Boolean is
      pragma Unreferenced (S);
   begin
      return True;
   end;
end Always_True;
