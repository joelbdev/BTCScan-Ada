with Base58;
with Ada.Streams; use Ada.Streams;

package BIP32_Public is

   function Validate (S : String) return Boolean;
   
private
   subtype BT_Checksum is Stream_Element_Array (1 .. 4);
   
   function Double_Sha256 (S : Stream_Element_Array) return BT_Checksum;

end BIP32_Public;
