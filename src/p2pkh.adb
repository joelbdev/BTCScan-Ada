with GNAT.SHA256; use GNAT.SHA256;

package body P2PKH is
   
   function Hex_Val (C, C2 : Character) return Stream_Element is
      subtype Nibble is Integer range 0 .. 15;
      HEX : array (0 .. 255) of Nibble :=
        (48=>0,  49=>1,  50=>2,  51=>3,   52=>4,   53=>5, 54=>6, 55=>7, 56=>8, 57=>9,
         65=>10, 66=>11, 67=>12, 68=>13,  69=>14,  70=>15,
         97=>10, 98=>11, 99=>12, 100=>13, 101=>14, 102=>15,
         others=>0);
   begin
      return Stream_Element (HEX (Character'Pos (C)) * 16 + HEX (Character'Pos (C2)));
   end Hex_Val;
   
   function Double_Sha256 (S : Stream_Element_Array) return BT_Checksum is
      Ctx  : Context := Initial_Context;
      D    : Message_Digest;
      S2   : Stream_Element_Array (1 .. 32);
      Ctx2 : Context := Initial_Context;
      C    : BT_Checksum;
   begin
      Update (Ctx, S);
      D := Digest (Ctx);
      for I in S2'Range loop
         S2 (I) := Hex_Val (D (Integer (I) * 2 - 1), D (Integer (I) * 2));
      end loop;
      Update (Ctx2, S2);
      D := Digest (Ctx2);
      for I in C'Range loop
         C (I) := Hex_Val (D (Integer (I) * 2 - 1), D (Integer (I) * 2));
      end loop;
      return C;
   end Double_Sha256;
      

   function Validate (S : String) return Boolean is
      package BTC_Base58 is new Base58(Stream_Length => 25);
      
      Base58_Stream : BTC_Base58.Base58_Raw_Type;
   begin
      BTC_Base58.Decode (S => S,
                         R => Base58_Stream);
      
      return Base58_Stream(1) = 0 and Base58_Stream(22..25) = Double_Sha256(Base58_Stream(1..21));
   exception
      when BTC_Base58.Invalid_Address_Error => return False;
   end Validate;

end P2PKH;
