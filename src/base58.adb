-- Adapted from https://rosettacode.org/wiki/Bitcoin/address_validation#Ada

with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body Base58 is
   
   procedure Decode (S : String; R : out Base58_Raw_Type) is
   begin
      R := (others => 0);
      for I in S'Range loop
         declare
            P : Natural := Index(Base58_Values, String(S(I..I)));
            C : Natural;
         begin
            if P = 0 then
               raise Invalid_Address_Error;
            end if;
            C := P - 1;
            for J in reverse R'Range loop
               C    := C + Natural(R(J)) * 58;
               R(J) := Stream_Element(Unsigned_32(C) and 255);
               C    := Natural(Shift_Right(Unsigned_32(C), 8) and 255);
            end loop;
            if C /= 0 then
               raise Invalid_Address_Error;
            end if;
         end;
      end loop;
   end Decode;

end Base58;
